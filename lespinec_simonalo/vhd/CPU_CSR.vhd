library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.PKG.all;

entity CPU_CSR is
    generic (
        INTERRUPT_VECTOR : waddr   := w32_zero;
        mutant           : integer := 0
    );
    port (
        clk         : in  std_logic;
        rst         : in  std_logic;

        -- Interface de et vers la PO
        cmd         : in  PO_cs_cmd;
        it          : out std_logic;
        pc          : in  w32;
        rs1         : in  w32;
        imm         : in  W32;
        csr         : out w32;
        mtvec       : out w32;
        mepc        : out w32;

        -- Interface de et vers les IP d'interruption
        irq         : in  std_logic;
        meip        : in  std_logic;
        mtip        : in  std_logic;
        mie         : out w32;
        mip         : out w32;
        mcause      : in  w32
    );
end entity;

architecture RTL of CPU_CSR is
    -- Fonction retournant la valeur à écrire dans un csr en fonction
    -- du « mode » d'écriture, qui dépend de l'instruction
    function CSR_write (CSR        : w32;
                         CSR_reg    : w32;
                         WRITE_mode : CSR_WRITE_mode_type)
        return w32 is
        variable res : w32;
    begin
        case WRITE_mode is
            when WRITE_mode_simple =>
                res := CSR;
            when WRITE_mode_set =>
                res := CSR_reg or CSR;
            when WRITE_mode_clear =>
                res := CSR_reg and (not CSR);
            when others => null;
        end case;
        return res;
    end CSR_write;

    -- Registre de controle/statut
    signal mcause_D, mcause_Q   : w32;
    signal mtval_D, mtval_Q     : w32;
    signal mip_D, mip_Q         : w32;
    signal mie_D, mie_Q         : w32;
    signal mstatus_D, mstatus_Q : w32;
    signal mtvec_D, mtvec_Q     : w32;
    signal mepc_D, mepc_Q       : w32;
	-- Registre IRQ
    signal irq_Q, irq_D : std_logic;
	-- CSR
	signal TO_CSR : w32;

begin
	do_reg: process(clk)
	begin
		if clk'event and clk='1' then
			if rst = '1' then
				mcause_Q    <= w32_zero;
				mtval_Q     <= w32_zero;
				mip_Q       <= w32_zero;
				mie_Q       <= w32_zero;
				mstatus_Q   <= w32_zero;
				mtvec_Q     <= INTERRUPT_VECTOR;
				mepc_Q      <= w32_zero;
				irq_Q       <= '0';
			else
				mcause_Q    <= mcause_D;
				mtval_Q     <= mtval_D;
				mip_Q       <= mip_D;
				mie_Q       <= mie_D;
				mstatus_Q   <= mstatus_D;
				mtvec_Q     <= mtvec_D;
				mepc_Q      <= mepc_D;
				irq_Q       <= irq_D;
			end if;
		end if;
	end process do_reg;

	input_reg: process(all)
	begin
		-- valeur de base : ancienne valeur
		mcause_D    <= mcause_Q;
		mtval_D     <= mtval_Q;
		mip_D       <= mip_Q;
		mie_D       <= mie_Q;
		mstatus_D   <= mstatus_Q;
		mtvec_D     <= mtvec_Q;
		mepc_D      <= mepc_Q;
		irq_D       <= irq_Q;

		-- Séléction des données
		case cmd.TO_CSR_Sel is
			when TO_CSR_from_rs1 =>
                TO_CSR <= rs1;
			when TO_CSR_from_imm =>
				TO_CSR <= imm;
			when others => null;
		end case;

		mip_D(7)    <= mtip;
		mip_D(11)   <= meip;
        irq_D       <= irq;
        
        -- mise à jour de mcause
		case irq_Q is
			when '1' =>
				mcause_D <= CSR_write(TO_CSR, mcause, cmd.CSR_WRITE_mode);
			when others => null;
        end case;
        
        -- mise à jour en fonction des we
		case cmd.CSR_we is
			when CSR_mie =>
				mie_D <= CSR_write(TO_CSR, mie_Q, cmd.CSR_WRITE_mode);
			when CSR_mstatus =>
				mstatus_D <= CSR_write(TO_CSR, mstatus_Q, cmd.CSR_WRITE_mode);
			when CSR_mtvec =>
				mtvec_D <= CSR_write(TO_CSR, mtvec_Q, cmd.CSR_WRITE_mode);
				mtvec_D(0) <= '0';
				mtvec_D(1) <= '0';
			when CSR_mepc =>
				case cmd.MEPC_sel is
					when MEPC_from_csr =>
						mepc_D <= CSR_write(TO_CSR, mepc_Q, cmd.CSR_WRITE_mode);
					when MEPC_from_pc =>
						mepc_D <= CSR_write(pc, mepc_Q, cmd.CSR_WRITE_mode);
					when others => null;
				end case;
				mepc_D(0) <= '0';
				mepc_D(1) <= '0';
			when others => null;
		end case;

		case cmd.MSTATUS_mie_set is
			when '1' =>
				mstatus_D(3) <= '1';
			when others => null;
		end case;

		case cmd.MSTATUS_mie_reset is
			when '1' =>
				mstatus_D(3) <= '0';
				when others => null;
		end case;
        
    -- Séléction de la sortie
	case cmd.CSR_sel is
		when CSR_from_mcause =>
			CSR <= mcause_Q;
		when CSR_from_mip =>
			CSR <= mip_Q;
		when CSR_from_mie =>
			CSR <= mie_Q;
		when CSR_from_mstatus =>
			CSR <= mstatus_Q;
		when CSR_from_mtvec =>
			CSR <= mtvec_Q;
		when CSR_from_mepc =>
			CSR <= mepc_Q;
		when others => null;
	end case;
	end process input_reg;

	mepc    <= mepc_Q;
	mtvec   <= mtvec_Q;
	mip     <= mip_Q;
	mie     <= mie_Q;
	it      <= irq_Q and mstatus_Q(3);

end architecture;
