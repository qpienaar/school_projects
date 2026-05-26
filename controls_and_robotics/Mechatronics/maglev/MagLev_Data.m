classdef MagLev_Data
    properties
        % Full data columns
        data
        d
        PWM
        volts
        hall
        w

        % Distance group subsets
        d1
        d2
        d3

        PWM1
        PWM2
        PWM3

        volts1
        volts2
        volts3

        hall1
        hall2
        hall3

        w1
        w2
        w3
    end

    methods
        % ---- Constructor ----
        function obj = MagLev_Data()
            % raw data stored in matrix
            % distance (m) PWM Volts(V) Hall Sensor Weight(g)
            obj.data = [ ...
                .022  0   0    671  -1.54;
                .022 100 .29  680  -2.48;
                .022 90  .19  680  -2.18;
                .022 60  .09  675  -1.83;
                .022 70  .10  680  -1.91;
                .022 80  .15  680  -2.00;
                .022 105 .35  683  -2.69;
                .03  0   0    560  -0.38;
                .03  100 .29  570  -0.88;
                .03  150 .85  590  -1.82;
                .03  200 1.27 610  -2.58;
                .03  220 1.35 610  -2.87;
                .03  230 1.42 610  -3.00;
                .038 0   0    530  -0.18;
                .038 100 .30  545  -0.49;
                .038 150 .87  560  -0.90;
                .038 200 1.27 570  -1.38;
                .038 255 1.73 586  -1.83];

            % Pre-calc full columns
            obj.d     = obj.data(:,1);
            obj.PWM   = obj.data(:,2);
            obj.volts = obj.data(:,3);
            obj.hall  = obj.data(:,4);
            obj.w     = obj.data(:,5);

            % ---- Create grouped datasets ----
            obj.d1 = obj.d(1:7);
            obj.d2 = obj.d(8:13);
            obj.d3 = obj.d(14:18);

            obj.PWM1 = obj.PWM(1:7);
            obj.PWM2 = obj.PWM(8:13);
            obj.PWM3 = obj.PWM(14:18);

            obj.volts1 = obj.volts(1:7);
            obj.volts2 = obj.volts(8:13);
            obj.volts3 = obj.volts(14:18);

            obj.hall1 = obj.hall(1:7);
            obj.hall2 = obj.hall(8:13);
            obj.hall3 = obj.hall(14:18);

            obj.w1 = obj.w(1:7);
            obj.w2 = obj.w(8:13);
            obj.w3 = obj.w(14:18);
        end

        % ---- Getter functions ----

        function out = getHall(obj), out = obj.hall; end
        function out = getPWM(obj), out = obj.PWM; end
        function out = getDistance(obj), out = obj.d; end
        function out = getVolts(obj), out = obj.volts; end

        function out = getHall1(obj), out = obj.hall1; end
        function out = getHall2(obj), out = obj.hall2; end
        function out = getHall3(obj), out = obj.hall3; end

        function out = getVolts1(obj), out = obj.volts1; end
        function out = getVolts2(obj), out = obj.volts2; end
        function out = getVolts3(obj), out = obj.volts3; end

        function out = getPWM1(obj), out = obj.PWM1; end
        function out = getPWM2(obj), out = obj.PWM2; end
        function out = getPWM3(obj), out = obj.PWM3; end

        function out = getD1(obj), out = obj.d1; end
        function out = getD2(obj), out = obj.d2; end
        function out = getD3(obj), out = obj.d3; end

        function out = getW1(obj), out = obj.w1; end
        function out = getW2(obj), out = obj.w2; end
        function out = getW3(obj), out = obj.w3; end
    end
end
