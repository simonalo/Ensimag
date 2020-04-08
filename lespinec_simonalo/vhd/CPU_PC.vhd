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
		S_LB		
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
		cmd.rst               <= '0';
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

		cmd.cs.CSR_we            <= UNDEFINED;

		cmd.cs.TO_CSR_sel        <= UNDEFINED;
		cmd.cs.CSR_sel           <= UNDEFINED;
		cmd.cs.MEPC_sel          <= UNDEFINED;

		cmd.cs.MSTATUS_mie_set   <= '0';
		cmd.cs.MSTATUS_mie_reset <= '0';

		cmd.cs.CSR_WRITE_mode    <= UNDEFINED;

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
				state_d <= S_Decode;

			when S_Decode =>

				-- Instruction lui
				if status.IR(6 downto 0) = "0110111" then
					-- Pc <- PC + 4
					cmd.TO_PC_Y_sel <= TO_PC_Y_cst_x04;
					cmd.PC_sel <= PC_from_pc;
					cmd.PC_we <= '1';
					state_d <= S_LUI;
				
				-- Intruction auipc
				elsif status.IR(6 downto 0) = "0010111" then
					state_d <= S_AUIPC;

				-- Instructions de branchements
               	elsif status.IR(6 downto 0) = "1100011" then
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
				elsif status.IR(6 downto 0) = "0000011" then
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
				
				-- Instructions du type "registre immédiat"
				elsif status.IR(6 downto 0) = "0010011" then
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
				elsif status.IR(6 downto 0) = "0110011" then
					-- Pc <- PC + 4
					cmd.TO_PC_Y_sel <= TO_PC_Y_cst_x04;
					cmd.PC_sel <= PC_from_pc;
					cmd.PC_we <= '1';
					-- Choix del'état futur
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
				

					
				else
					state_d <= S_Error;
				end if;



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

---------- Instructions d'accès aux CSR ----------

			when others => null;
		end case;

	end process FSM_comb;

end architecture;
