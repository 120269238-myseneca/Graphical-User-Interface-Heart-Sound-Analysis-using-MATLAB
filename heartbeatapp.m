classdef app1 &lt; matlab.apps.AppBase

% Properties that correspond to app components
properties (Access = public)
UIFigure matlab.ui.Figure
StartAnalysisButton matlab.ui.control.Button
SelectFileButton matlab.ui.control.Button
FileSelectedNoneLabel matlab.ui.control.Label
AudioLengthLabel matlab.ui.control.Label
BeatsPerMinuteLabel matlab.ui.control.Label
end

properties (Access = public)
filename % Stores file name
end

% Callbacks that handle component events
methods (Access = private)

7

% Button pushed function: StartAnalysisButton
function start(app, event)
[origfile,origfs] = audioread(app.filename);
A = origfile(1:10:end);
fs = origfs/10;
figure;
plot(A);
title(&quot;Plot of Original Sound Wave&quot;);
xlabel(&quot;Samples&quot;);
time = length(A)/fs;
app.AudioLengthLabel.Text=&quot;Audio Length: &quot;+time+&quot; seconds&quot;;
app.AudioLengthLabel.Enable=true;
app.AudioLengthLabel.Visible=true;
bpm = 0;
figure;
bp = bandpass(A,[70 120],fs);
plot(bp);
title(&quot;Plot of Bandpass Filtered Sound Wave&quot;);
xlabel(&quot;Samples&quot;);
m = prctile(bp,99)
figure;
findpeaks(bp,&#39;MinPeakHeight&#39;,m,&#39;MinPeakDistance&#39;,250);
title(&quot;Plot of Filtered Sound Wave with Peaks&quot;);
xlabel(&quot;Samples&quot;);
peaks = findpeaks(bp,&#39;MinPeakHeight&#39;,m,&#39;MinPeakDistance&#39;,250);
beats = round(length(peaks)/2);
bpm = (beats/time)*60;
app.BeatsPerMinuteLabel.Text = &quot;Beats Per Minute: &quot;+bpm;
app.BeatsPerMinuteLabel.Visible = true;
app.BeatsPerMinuteLabel.Enable = true;
end
% Button pushed function: SelectFileButton
function selfile(app, event)

app.filename = uigetfile(&#39;*.*&#39;);
app.StartAnalysisButton.Enable = true;
app.FileSelectedNoneLabel.Text = &quot;File Selected: &quot;+app.filename;
end
end

% Component initialization
methods (Access = private)

% Create UIFigure and components
function createComponents(app)

8

% Create UIFigure and hide until all components are created
app.UIFigure = uifigure(&#39;Visible&#39;, &#39;off&#39;);
app.UIFigure.Position = [100 100 640 480];
app.UIFigure.Name = &#39;MATLAB App&#39;;

% Create StartAnalysisButton
app.StartAnalysisButton = uibutton(app.UIFigure, &#39;push&#39;);
app.StartAnalysisButton.ButtonPushedFcn = createCallbackFcn(app,
@start, true);
app.StartAnalysisButton.IconAlignment = &#39;right&#39;;
app.StartAnalysisButton.Enable = &#39;off&#39;;
app.StartAnalysisButton.Tooltip = {&#39;&#39;};
app.StartAnalysisButton.Position = [333 262 134 32];
app.StartAnalysisButton.Text = &#39;Start Analysis&#39;;

% Create SelectFileButton
app.SelectFileButton = uibutton(app.UIFigure, &#39;push&#39;);
app.SelectFileButton.ButtonPushedFcn = createCallbackFcn(app,
@selfile, true);
app.SelectFileButton.Position = [132 262 136 32];
app.SelectFileButton.Text = &#39;Select File&#39;;

% Create FileSelectedNoneLabel
app.FileSelectedNoneLabel = uilabel(app.UIFigure);
app.FileSelectedNoneLabel.Position = [132 199 171 43];
app.FileSelectedNoneLabel.Text = {&#39;File Selected: None&#39;; &#39;&#39;};

% Create AudioLengthLabel
app.AudioLengthLabel = uilabel(app.UIFigure);
app.AudioLengthLabel.Enable = &#39;off&#39;;
app.AudioLengthLabel.Visible = &#39;off&#39;;
app.AudioLengthLabel.Position = [132 188 291 22];
app.AudioLengthLabel.Text = &#39;Audio Length&#39;;

% Create BeatsPerMinuteLabel
app.BeatsPerMinuteLabel = uilabel(app.UIFigure);
app.BeatsPerMinuteLabel.Enable = &#39;off&#39;;
app.BeatsPerMinuteLabel.Visible = &#39;off&#39;;
app.BeatsPerMinuteLabel.Position = [132 156 291 22];
app.BeatsPerMinuteLabel.Text = &#39;Beats Per Minute: &#39;;

% Show the figure after all components are created
app.UIFigure.Visible = &#39;on&#39;;
end

9

end
% App creation and deletion
methods (Access = public)

% Construct app
function app = app1

% Create UIFigure and components
createComponents(app)

% Register the app with App Designer
registerApp(app, app.UIFigure)

if nargout == 0
clear app
end
end

% Code that executes before app deletion
function delete(app)

% Delete UIFigure when app is deleted
delete(app.UIFigure)
end
end
end
