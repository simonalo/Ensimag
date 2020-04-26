library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library work;
use work.PKG.all;


entity CPU_PC is
	generic(
		mutant: integer := 0
	);
	Port (
		-- Clock/Reset
		clk    : in  std_logic ;
		rst    : in  std_logic ;

		-- Interface PC to PO
		cmd    : out PO_cmd ;
		status : in  PO_status
	);
end entity;

architecture RTL of CPU_PC is
	type State_type is (
		S_Error,
		S_Init,
		S_Pre_Fetch,
		S_Fetch,
		S_Decode,
		S_LUI,
		S_ADDI,
		S_ADD,
		S_AUIPC,
		S_SLL,
		S_SRL,
		S_SRA,
		S_SRAI,
		S_SLLI,
		S_SRLI,
		S_SUB,
		S_AND,
		S_OR,
		S_XOR,
		S_ANDI,
		S_ORI,
		S_XORI,
		S_SLT,
		S_SLTI,
		S_SLTU,
		S_SLTIU,
        S_BEQ,
        S_BGE,
        S_BGEU,
        S_BLT,
        S_BLTU,
		S_BNE,
		S_READ_MEM,
		S_LOAD_MEM,
		S_LW,
		S_LHU,
		S_LH,
		S_LBU,
		S_LB,
        S_WRITE_MEM,
        S_SW,
        S_SB,
        S_SH,
        S_JAL,
		S_JALR,
		S_Interrupt,
		S_IR_SAVE,
		S_MRET,
		S_CSRR,
		S_MUL_DIV_REM
	);

	signal state_d, state_q : State_type;


begin

	FSM_synchrone : process(clk)
	begin
		if clk'event and clk='1' then
			if rst='1' then
				state_q <= S_Init;
			else
				state_q <= state_d;
			end if;
		end if;
	end process FSM_synchrone;

	FSM_comb : process (state_q, status)
	begin

		-- Valeurs par défaut de cmd à définir selon les préférences de chacun
		cmd.ALU_op            <= ALU_plus;
		cmd.LOGICAL_op        <= LOGICAL_and;
		cmd.ALU_Y_sel         <= ALU_Y_immI;

		cmd.SHIFTER_op        <= SHIFT_rl;
		cmd.SHIFTER_Y_sel     <= SHIFTER_Y_rs2;

		cmd.RF_we             <= '0';
		cmd.RF_SIZE_sel       <= RF_SIZE_word;
		cmd.RF_SIGN_enable    <= '0';
		cmd.DATA_sel          <= DATA_from_pc;

		cmd.PC_we             <= '0';
		cmd.PC_sel            <= PC_from_mepc;

		cmd.PC_X_sel          <= PC_X_cst_x00;
		cmd.PC_Y_sel          <= PC_Y_cst_x04;

		cmd.TO_PC_Y_sel       <= TO_PC_Y_cst_x04;

		cmd.AD_we             <= '0';
		cmd.AD_Y_sel          <= AD_Y_immI;

		cmd.IR_we             <= '0';

		cmd.ADDR_sel          <= ADDR_from_pc;
		cmd.mem_we            <= '0';
		cmd.mem_ce            <= '0';

		cmd.cs.CSR_we            <= CSR_none;

		cmd.cs.TO_CSR_sel        <= TO_CSR_from_rs1;
		cmd.cs.CSR_sel           <= CSR_from_mepc;
		cmd.cs.MEPC_sel          <= MEPC_from_csr;

		cmd.cs.MSTATUS_mie_set   <= '0';
		cmd.cs.MSTATUS_mie_reset <= '0';

		cmd.cs.CSR_WRITE_mode    <= WRITE_mode_simple;

		-- Deuxième ALU
		cmd.ALU2_op_type		<= ALU_mul;

		state_d <= state_q;

		case state_q is
			when S_Error =>
				-- Etat transitoire en cas d'instruction non reconnue
				-- Aucune action
				state_d <= S_Init;

			when S_Init =>
				-- PC <- RESET_VECTOR
				cmd.PC_we <= '1';
				cmd.PC_sel <= PC_rstvec;
				state_d <= S_Pre_Fetch;

			when S_Pre_Fetch =>
				-- mem[PC]
				cmd.mem_we   <= '0';
				cmd.mem_ce   <= '1';
				cmd.ADDR_sel <= ADDR_from_pc;
				state_d      <= S_Fetch;

			when S_Fetch =>
				-- IR <- mem_datain
				cmd.IR_we <= '1';

				if status.IT then
					state_d <= S_IR_SAVE;
				else
					state_d <= S_Decode;
				end if;

			when S_Decode =>
                case status.IR(6 downto 0) is
			    	-- Instruction lui
                    when  "0110111" =>
					    -- Pc <- PC + 4
					    cmd.TO_PC_Y_sel <= TO_PC_Y_cst_x04;
					    cmd.PC_sel <= PC_from_pc;
					    cmd.PC_we <= '1';
					    state_d <= S_LUI;
				
				    -- Intruction auipc
                    when "0010111" =>
					    state_d <= S_AUIPC;

			    	-- Instructions de branchements
                    when "1100011" =>
                	    cmd.ALU_Y_sel <= ALU_Y_rf_rs2;
                        if status.IR(14 downto 12)="000" then
				            state_d <= S_BEQ;
                        elsif status.IR(14 downto 12) = "101" then
                            state_d <= S_BGE;
                        elsif status.IR(14 downto 12) = "111" then
                            state_d <= S_BGEU;
                        elsif status.IR(14 downto 12) = "100" then
                            state_d <= S_BLT;
                        elsif status.IR(14 downto 12) = "110" then
                            state_d <= S_BLTU;
                        else
                            state_d <= S_BNE;
					    end if;

			    	-- Instructions de lecture en mémoire
                    when "0000011" =>
				    	-- Pc <- Pc + 4
					    cmd.TO_PC_Y_sel <= TO_PC_Y_cst_x04;
					    cmd.PC_sel <= PC_from_pc;
					    cmd.PC_we <= '1';
					    -- Choix de l'état futur
					    if status.IR(14 downto 12) = "000" then
						    state_d <= S_LB;
					    elsif status.IR(14 downto 12) = "001" then
						    state_d <= S_LH;
					    elsif status.IR(14 downto 12) = "010" then
						    state_d <= S_LW;
					    elsif status.IR(14 downto 12) = "100" then
						    state_d <= S_LBU;
					    elsif status.IR(14 downto 12) = "101" then
						    state_d <= S_LHU;
					    end if;
			        ---Instructions d'écriture en mémoire---
                    when "0100011" =>
                        cmd.TO_PC_Y_sel <= TO_PC_Y_cst_x04;
                        cmd.PC_sel <= PC_from_pc;
                        cmd.PC_we <= '1';
                        ---choix état futur---
                        if status.IR(14 downto 12)="010" then
                            state_d <= S_SW;
                        elsif status.IR(14 downto 12)="001" then
                            state_d <= S_SH;
                        elsif status.IR(14 downto 12)="000" then
                            state_d <= S_SB;
                        end if;


				    -- Instructions du type "registre immédiat"
                    when "0010011" =>
					    -- Pc <- PC + 4
					    cmd.TO_PC_Y_sel <= TO_PC_Y_cst_x04;
					    cmd.PC_sel <= PC_from_pc;
					    cmd.PC_we <= '1';
					    -- Choix de l'état futur
					    if status.IR(14 downto 12) = "000" then
						    state_d <= S_ADDI;
					    elsif status.IR(14 downto 12) = "001" then
						    state_d <= S_SLLI;
					    elsif status.IR(14 downto 12) = "111" then
						    state_d <=S_ANDI;
					    elsif status.IR(14 downto 12) = "110" then
						    state_d <= S_ORI;
					    elsif status.IR(14 downto 12) = "100" then
						    state_d <= S_XORI;
					    elsif status.IR(14 downto 12) = "010" then
						    state_d <= S_SLTI;
					    elsif status.IR(14 downto 12) = "011" then
						    state_d <= S_SLTIU;
					    else -- status.IR(14 downto 12) = "101"
						    if status.IR(31 downto 25) = "0100000" then
							    state_d <= S_SRAI;
						    else
							    state_d <= S_SRLI;
						    end if;
					    end if;

				    -- Instructions du type "registre registre"
                    when "0110011" =>
					    -- Pc <- PC + 4
					    cmd.TO_PC_Y_sel <= TO_PC_Y_cst_x04;
				    	cmd.PC_sel <= PC_from_pc;
					    cmd.PC_we <= '1';
						-- Choix de l'état futur
						-- Cas des multiplications, divisions et reste
						if status.IR(31 downto 25) = "0000001" then
							state_d <= S_MUL_DIV_REM;
						else
							if status.IR(14 downto 12) = "000" then
								if status.IR(31 downto 25) = "0100000"then
									state_d <= S_SUB;
								else
									state_d <= S_ADD;
								end if;
							elsif status.IR(14 downto 12) = "001" then
									state_d <= S_SLL;
							elsif status.IR(14 downto 12) = "101" then
								if status.IR(31 downto 25) = "0100000" then
									state_d <= S_SRA;
								else
									state_d <= S_SRL;
								end if;
							elsif status.IR(14 downto 12) = "111" then
									state_d <= S_AND;
							elsif status.IR(14 downto 12) = "110" then
									state_d <= S_OR;
							elsif status.IR(14 downto 12) = "100" then
									state_d <= S_XOR;
							elsif status.IR(14 downto 12) = "010" then
								state_d <= S_SLT;
							elsif status.IR(14 downto 12) = "011" then
								state_d <= S_SLTU;
							end if;
						end if;
				    ---instructions type saut---
                    when "1101111" =>
                        state_d <= S_JAL;
                    when "1100111" =>
					    state_d <= S_JALR;
					---instructions type interruptions---
					when "1110011" =>
						-- Pc <- PC + 4
						cmd.TO_PC_Y_sel <= TO_PC_Y_cst_x04;
						cmd.PC_sel <= PC_from_pc;
						cmd.PC_we <= '1';
						
						if status.IR(14 downto 12) = "000" then
							state_d <= S_MRET;
						else
							state_d <= S_CSRR;
						end if;
                    when others =>
						state_d <= S_Error;
				    end case;



---------- Instructions avec immediat de type U ----------
			when S_LUI =>
				-- rd <- ImmU + 0
				cmd.PC_X_sel <= PC_X_cst_x00;
				cmd.PC_Y_sel <= PC_Y_immU;
				cmd.RF_we <= '1';
				cmd.DATA_sel <= DATA_from_pc;
				-- lecture mem[PC]
				cmd.ADDR_sel <= ADDR_from_pc;
				cmd.mem_ce <= '1';
				cmd.mem_we <= '0';
				-- next state
				state_d <= S_FETCH;

---------- Instructions arithmétiques et logiques ----------
			-- Addition avec immédiat
			when S_ADDI =>
				-- rd <- rs1 + immI
				cmd.ALU_op <= ALU_plus;
				cmd.ALU_Y_sel <= ALU_Y_immI;
				cmd.RF_we <= '1';
				cmd.DATA_sel <= DATA_from_alu;
				-- lecture mem[PC]
				cmd.ADDR_sel <= ADDR_from_pc;
				cmd.mem_ce <= '1';
				cmd.mem_we <= '0';
				-- next state
				state_d <= S_Fetch;
            -- Addition registre registre signé
			when S_ADD =>
				-- rd <- rs1 + rs2
				cmd.ALU_op <= ALU_plus;
				cmd.ALU_Y_sel <=ALU_Y_rf_rs2;
				cmd.RF_we <= '1';
				cmd.DATA_sel <= DATA_from_alu;
				-- lecture mem[PC]
				cmd.ADDR_sel <= ADDR_from_pc;
				cmd.mem_ce <= '1';
				cmd.mem_we <= '0';
				-- next state
				state_d <= S_Fetch;

			-- Soustraction registre registre signé
			when S_SUB =>
				-- rd <- rs1 + rs2
				cmd.ALU_op <= ALU_minus;
				cmd.ALU_Y_sel <=ALU_Y_rf_rs2;
				cmd.RF_we <= '1';
				cmd.DATA_sel <= DATA_from_alu;
				-- lecture mem[PC]
				cmd.ADDR_sel <= ADDR_from_pc;
				cmd.mem_ce <= '1';
				cmd.mem_we <= '0';
				-- next state
				state_d <= S_Fetch;

			-- Addition d'un immédiat aux bits de poids fort de pc
			when S_AUIPC =>
				-- rd <- (IR_{31...12} || 0^{12}) + pc
				cmd.PC_X_sel <= PC_X_pc;
				cmd.PC_Y_sel <= PC_Y_immU;
				cmd.RF_we <= '1';
				cmd.DATA_sel <= DATA_from_pc;
				-- Pc <- PC + 4
				cmd.TO_PC_Y_sel <= TO_PC_Y_cst_x04;
				cmd.PC_sel <= PC_from_pc;
				cmd.PC_we <= '1';
				-- next state
				state_d <= S_Pre_Fetch;

			-- Décalage à gauche
			when S_SLL =>
				---decalage a gauche
				cmd.SHIFTER_Y_sel <= SHIFTER_Y_rs2;
				cmd.SHIFTER_op <= SHIFT_ll;
				cmd.DATA_sel <= DATA_from_shifter;
				cmd.RF_we <= '1';
				--- lecture mem[PC]
				cmd.ADDR_sel <= ADDR_from_pc;
				cmd.mem_ce <= '1';
				cmd.mem_we <= '0';
				-- next state
				state_d <= S_Fetch;

			-- Décalage à droite logique registre
			when S_SRL =>
				---decalage a droite
				cmd.SHIFTER_op <= SHIFT_rl;
				cmd.SHIFTER_Y_sel <= SHIFTER_Y_rs2;
				cmd.DATA_sel <= DATA_from_shifter;
				cmd.RF_we <= '1';
				--- lecture mem[PC]
				cmd.ADDR_sel <= ADDR_from_pc;
				cmd.mem_ce <= '1';
				cmd.mem_we <= '0';
				-- next state
				state_d <= S_Fetch;

			-- Décalage à droite arithmétique registre
			when S_SRA =>
				---decalage a droite
				cmd.SHIFTER_op <= SHIFT_ra;
				cmd.SHIFTER_Y_sel <= SHIFTER_Y_rs2;
				cmd.DATA_sel <= DATA_from_shifter;
				cmd.RF_we <= '1';
				--- lecture mem[PC]
				cmd.ADDR_sel <= ADDR_from_pc;
				cmd.mem_ce <= '1';
				cmd.mem_we <= '0';
				-- next state
				state_d <= S_Fetch;

			-- Décalage à droite arithmétique immédiat
			when S_SRAI =>
				---decalage a droite
				cmd.SHIFTER_op <= SHIFT_ra;
				cmd.SHIFTER_Y_sel <= SHIFTER_Y_ir_sh;
				cmd.DATA_sel <= DATA_from_shifter;
				cmd.RF_we <= '1';
				--- lecture mem[PC]
				cmd.ADDR_sel <= ADDR_from_pc;
				cmd.mem_ce <= '1';
				cmd.mem_we <= '0';
				-- next state
				state_d <= S_Fetch;

			-- Décalage à gauche immédiat
			when S_SLLI =>
				---decalage a gauche
				cmd.SHIFTER_Y_sel <= SHIFTER_Y_ir_sh;
				cmd.SHIFTER_op <= SHIFT_ll;
				cmd.DATA_sel <= DATA_from_shifter;
				cmd.RF_we <= '1';
				--- lecture mem[PC]
				cmd.ADDR_sel <= ADDR_from_pc;
				cmd.mem_ce <= '1';
				cmd.mem_we <= '0';
				-- next state
				state_d <= S_Fetch;

			-- Décalage à droite logique immédiat
			when S_SRLI =>
				---decalage a gauche
				cmd.SHIFTER_Y_sel <= SHIFTER_Y_ir_sh;
				cmd.SHIFTER_op <= SHIFT_rl;
				cmd.DATA_sel <= DATA_from_shifter;
				cmd.RF_we <= '1';
				--- lecture mem[PC]
				cmd.ADDR_sel <= ADDR_from_pc;
				cmd.mem_ce <= '1';
				cmd.mem_we <= '0';
				-- next state
				state_d <= S_Fetch;
			
			-- Et bit-à-bit registre registre
			when S_AND =>
				cmd.RF_we <= '1';
				cmd.ALU_Y_sel <= ALU_Y_rf_rs2;
				cmd.LOGICAL_op <= LOGICAL_and;
				cmd.DATA_sel <= DATA_from_logical;
			 	-- lecture mem[PC]
				cmd.ADDR_sel <= ADDR_from_pc;
				cmd.mem_ce <= '1';
				cmd.mem_we <= '0';
			 	-- next state
				state_d <= S_Fetch;
			
			-- Ou bit-à-bit registre registre
			when S_OR =>
				cmd.LOGICAL_op <= LOGICAL_or;
				cmd.ALU_Y_sel <=ALU_Y_rf_rs2;
				cmd.RF_we <= '1';
				cmd.DATA_sel <= DATA_from_logical;
				-- lecture mem[PC]
				cmd.ADDR_sel <= ADDR_from_pc;
				cmd.mem_ce <= '1';
				cmd.mem_we <= '0';
				-- next state
				state_d <= S_Fetch;

			-- Ou-exclusif bit-à-bit registre registre
			when S_XOR =>
				cmd.LOGICAL_op <= LOGICAL_xor;
				cmd.ALU_Y_sel <=ALU_Y_rf_rs2;
				cmd.RF_we <= '1';
				cmd.DATA_sel <= DATA_from_logical;
				-- lecture mem[PC]
				cmd.ADDR_sel <= ADDR_from_pc;
				cmd.mem_ce <= '1';
				cmd.mem_we <= '0';
				-- next state
				state_d <= S_Fetch;

			-- Et bit-à-bit registre immédiat
			when S_ANDI =>
				cmd.RF_we <= '1';
				cmd.ALU_Y_sel <= ALU_Y_immI;
				cmd.LOGICAL_op <= LOGICAL_and;
				cmd.DATA_sel <= DATA_from_logical;
			 -- lecture mem[PC]
				cmd.ADDR_sel <= ADDR_from_pc;
				cmd.mem_ce <= '1';
				cmd.mem_we <= '0';
			 -- next state
				state_d <= S_Fetch;

			-- Ou bit-à-bit registre immédiat
			when S_ORI =>
				cmd.LOGICAL_op <= LOGICAL_or;
				cmd.ALU_Y_sel <=ALU_Y_immI;
				cmd.RF_we <= '1';
				cmd.DATA_sel <= DATA_from_logical;
				-- lecture mem[PC]
				cmd.ADDR_sel <= ADDR_from_pc;
				cmd.mem_ce <= '1';
				cmd.mem_we <= '0';
				-- next state
				state_d <= S_Fetch;

			-- Ou-exclusif bit-à-bit registre immédiat
			when S_XORI =>
				cmd.LOGICAL_op <= LOGICAL_xor;
				cmd.ALU_Y_sel <=ALU_Y_immI;
				cmd.RF_we <= '1';
				cmd.DATA_sel <= DATA_from_logical;
				-- lecture mem[PC]
				cmd.ADDR_sel <= ADDR_from_pc;
				cmd.mem_ce <= '1';
				cmd.mem_we <= '0';
				-- next state
				state_d <= S_Fetch;

			-- Comparaison signée registre registre
			when S_SLT =>
				cmd.ALU_Y_SEL <= ALU_Y_rf_rs2;
				cmd.DATA_sel <= DATA_from_slt;
				cmd.RF_we <= '1';
				-- lecture mem[PC]
				cmd.ADDR_sel <= ADDR_from_pc;
				cmd.mem_ce <= '1';
				cmd.mem_we <= '0';
				-- next state
				state_d <= S_Fetch;

			-- Comparaison signée registre immédiat
			when S_SLTI =>
				cmd.ALU_Y_SEL <= ALU_Y_immI;
				cmd.DATA_sel <= DATA_from_slt;
				cmd.RF_we <= '1';
				-- lecture mem[PC]
				cmd.ADDR_sel <= ADDR_from_pc;
				cmd.mem_ce <= '1';
				cmd.mem_we <= '0';
				-- next state
				state_d <= S_Fetch;

			-- Comparaison non-signée registre registre
			when S_SLTU =>
				cmd.ALU_Y_SEL <= ALU_Y_rf_rs2;
				cmd.DATA_sel <= DATA_from_slt;
				cmd.RF_we <= '1';
				-- lecture mem[PC]
				cmd.ADDR_sel <= ADDR_from_pc;
				cmd.mem_ce <= '1';
				cmd.mem_we <= '0';
				-- next state
				state_d <= S_Fetch;

			-- Comparaison non-signée registre immédiat
			when S_SLTIU =>
				cmd.ALU_Y_SEL <= ALU_Y_immI;
				cmd.DATA_sel <= DATA_from_slt;
				cmd.RF_we <= '1';
				-- lecture mem[PC]
				cmd.ADDR_sel <= ADDR_from_pc;
				cmd.mem_ce <= '1';
				cmd.mem_we <= '0';
				-- next state
				state_d <= S_Fetch;

			when S_MUL_DIV_REM =>
				cmd.ALU_Y_sel <= ALU_Y_rf_rs2;

				if status.IR(14 downto 12)="000" then
					cmd.ALU2_op_type <= ALU_mul;
				elsif status.IR(14 downto 12)="001" then
					cmd.ALU2_op_type <= ALU_mulh;
				elsif status.IR(14 downto 12)="010" then
					cmd.ALU2_op_type <= ALU_mulhsu;
				elsif status.IR(14 downto 12)="011" then
					cmd.ALU2_op_type <= ALU_mulhu;
				end if;
				
				cmd.DATA_sel <= DATA_from_alu2;
				cmd.RF_we <= '1';

				-- lecture mem[PC]
				cmd.ADDR_sel <= ADDR_from_pc;
				cmd.mem_ce <= '1';
				cmd.mem_we <= '0';
				-- next state
				state_d <= S_Fetch;


---------- Instructions de saut ----------
           	when S_BEQ|S_BGE|S_BGEU|S_BLT|S_BLTU|S_BNE =>
                cmd.ALU_Y_sel <= ALU_Y_rf_rs2;
                if status.jcond then
                    cmd.TO_PC_Y_sel <= TO_PC_Y_immB;
                else
                    cmd.TO_PC_Y_sel <= TO_PC_Y_cst_x04;
                end if;
                cmd.PC_sel <= PC_from_pc;
                cmd.PC_we <= '1';
				state_d <= S_Pre_Fetch;

            when S_JAL =>
                cmd.PC_Y_sel <= PC_Y_cst_x04;
                cmd.PC_X_sel <= PC_X_pc;
                cmd.DATA_sel <= DATA_from_pc;
                cmd.RF_we <= '1';
                cmd.PC_sel <= PC_from_pc;
                cmd.TO_PC_Y_sel <= TO_PC_Y_immJ;
                cmd.PC_we <= '1';
                state_d <= S_Pre_Fetch;

            when S_JALR =>
                cmd.PC_Y_sel <= PC_Y_cst_x04;
                cmd.PC_X_sel <= PC_X_pc;
                cmd.DATA_sel <= DATA_from_pc;
                cmd.RF_we <= '1';
                cmd.ALU_Y_sel <= ALU_Y_immI;
                cmd.ALU_op <= ALU_plus;
                cmd.PC_sel <= PC_from_alu;
                cmd.PC_we <= '1';
                state_d <= S_Pre_Fetch;


---------- Instructions de chargement à partir de la mémoire ----------
			when S_LB|S_LH|S_LW|S_LBU|S_LHU =>
				cmd.AD_Y_SEL <= AD_Y_immI;
				cmd.AD_we <= '1';
				state_d <= S_READ_MEM;
			
			when S_READ_MEM =>
				cmd.ADDR_sel <= ADDR_from_ad;
				cmd.mem_ce <= '1';
				cmd.mem_we <= '0';
				state_d <= S_LOAD_MEM;

			when S_LOAD_MEM =>
				-- Lecture d’un octet signé de la mémoire
				if status.IR(14 downto 12) = "000" then
					cmd.RF_SIZE_sel <= RF_SIZE_byte;
					cmd.RF_SIGN_enable <= '1';
				-- Lecture d’un demi-mot signé de la mémoire
				elsif status.IR(14 downto 12) = "001" then
					cmd.RF_SIZE_sel <= RF_SIZE_half;
					cmd.RF_SIGN_enable <= '1';
				-- Lecture d’un mot de la mémoire
				elsif status.IR(14 downto 12) = "010" then
					cmd.RF_SIZE_sel <= RF_SIZE_word;
					cmd.RF_SIGN_enable <= '0';
				-- Lecture d’un octet non-signé de la mémoire
				elsif status.IR(14 downto 12) = "100" then
					cmd.RF_SIZE_sel <= RF_SIZE_byte;
					cmd.RF_SIGN_enable <= '0';
				-- Lecture d’un demi-mot non-signé de la mémoire
				elsif status.IR(14 downto 12) = "101" then
					cmd.RF_SIZE_sel <= RF_SIZE_half;
					cmd.RF_SIGN_enable <= '0';
				end if;

				cmd.DATA_sel <= DATA_from_mem;
				cmd.RF_we <= '1';
				
				-- lecture mem[PC]
				cmd.ADDR_sel <= ADDR_from_pc;
				cmd.mem_ce <= '1';
				cmd.mem_we <= '0';
				-- next state
				state_d <= S_Fetch;


---------- Instructions de sauvegarde en mémoire ----------
            when S_SW|S_SH|S_SB => -- on peut tout regrouper
                cmd.AD_Y_SEL <= AD_Y_immS;
                cmd.AD_we <= '1';
                state_d <= S_WRITE_MEM;
                -- Ok

            when S_WRITE_MEM =>
                if status.IR(14 downto 12)="010" then
                    cmd.RF_SIZE_sel <= RF_SIZE_word;
                elsif status.IR(14 downto 12)="001" then
                    cmd.RF_SIZE_sel <= RF_SIZE_half;
                elsif status.IR(14 downto 12)="000" then
                    cmd.RF_SIZE_sel <= RF_SIZE_byte;
                end if;
                cmd.ADDR_sel <= ADDR_from_ad;
                cmd.mem_ce <= '1';
                cmd.mem_we <= '1';
                state_d <= S_Pre_Fetch;


---------- Instructions d'accès aux CSR ----------
			when S_IR_SAVE =>
				-- On sauvegarde PC
				cmd.cs.MEPC_sel <= MEPC_from_pc;
				cmd.cs.CSR_we <= CSR_mepc;
				-- On maque les interruptions
				cmd.cs.MSTATUS_mie_reset <= '1';
				-- On charge PC avec mtvec
				cmd.PC_sel <= PC_mtvec;
				cmd.PC_we <= '1';

				state_d <= S_Pre_Fetch;

			when S_MRET =>
				-- On restaure PC
				cmd.PC_sel <= PC_from_mepc;
				cmd.PC_we <= '1';
				-- On démaque les interruptions
				cmd.cs.MSTATUS_mie_set <= '1';
				-- Prochain état
				state_d <= S_Pre_Fetch;

			when S_CSRR =>
				-- rd <- csr
				cmd.RF_we <= '1';
				cmd.DATA_sel <= DATA_from_csr;

				-- On choisit le registre où l'on va écrire
				if status.IR(31 downto 20)="001100000000" then
					cmd.cs.CSR_sel <= CSR_from_mstatus;
                    cmd.cs.CSR_we <= CSR_mstatus;
                elsif status.IR(31 downto 20)="001100000100" then
					cmd.cs.CSR_sel <= CSR_from_mie;
                    cmd.cs.CSR_we <= CSR_mie;
				elsif status.IR(31 downto 20)="001100000101" then
					cmd.cs.CSR_sel <= CSR_from_mtvec;
					cmd.cs.CSR_we <= CSR_mtvec;
				elsif status.IR(31 downto 20)="001101000001" then
					cmd.cs.MEPC_sel <= MEPC_from_csr;
					cmd.cs.CSR_sel <= CSR_from_mepc;
					cmd.cs.CSR_we <= CSR_mepc;
				elsif status.IR(31 downto 20)="001101000100" then
					cmd.cs.CSR_sel <= CSR_from_mip;
				elsif status.IR(31 downto 20)="001101000010" then
					cmd.cs.CSR_sel <= CSR_from_mcause;
				end if;
				
				-- On décide de ce que l'on va mettre dans CSR et le mode d'écriture (par défaut rs1)
				if status.IR(14 downto 12) = "001" then
					-- csr <- rs1 (csrrs)
					cmd.cs.CSR_WRITE_mode <= WRITE_mode_simple;
				elsif status.IR(14 downto 12) = "010" then
					-- csr <- csr or rs1 (csrrs)
					cmd.cs.CSR_WRITE_mode <= WRITE_mode_set;
				elsif status.IR(14 downto 12) = "011" then
					-- csr <- csr and (not rs1) (csrrc)
					cmd.cs.CSR_WRITE_mode <= WRITE_mode_clear;
				elsif status.IR(14 downto 12) = "101" then
					-- csr <- 0^27 || zimm (csrrwi)
					cmd.cs.TO_CSR_sel <= TO_CSR_from_imm;
				elsif status.IR(14 downto 12) = "110" then
					-- csr <- csr or (0^27 || zimm) (csrrsi)
					cmd.cs.TO_CSR_sel <= TO_CSR_from_imm;
					cmd.cs.CSR_WRITE_mode <= WRITE_mode_set;
				elsif status.IR(14 downto 12) = "111" then
					-- csr <- csr and (not (0^27 || zimm)) (csrrci)
					cmd.cs.TO_CSR_sel <= TO_CSR_from_imm;
					cmd.cs.CSR_WRITE_mode <= WRITE_mode_clear;
				end if;

				state_d <= S_Pre_Fetch;

			when others => null;
		end case;

	end process FSM_comb;

end architecture;
