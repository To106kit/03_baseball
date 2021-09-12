%%% $Author: DC $
%%%
%%% 関数名        : extract_butter
%%% (機能)        : 引数で指定されたurl内の打者成績を取得する。
%%%  　　         :
%%% (引数)        : a_url  (スクレイピング対象のurl)

%%% (戻り値)      : r_ret            (0:成功、1:失敗)
%%% (例外時の動作): -
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function r_ret = extract_butter(a_url)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% 初期化
r_ret = 1;
t_label_list = {'選手名', ...
                '打率',   ...
                '試合',   ...
                '打席数', ...
                '打数',   ...
                '安打',   ...
                '本塁打',  ...
                '打点',   ...
                '盗塁',   ...
                '四球',   ...
                '死球',   ...
                '三振',   ...
                '犠打',   ...
                '併殺打', ...
                '出塁率', ...
                '長打率', ...
                'OPS',   ...
                'RC27',  ...
                'XR27',  ...
                };
t_butterTbl_sta = '<tr'; % 打者成績表開始タグ
t_butterTbl_end = '</tr>';   % 打者成績終了タグ
t_player_sta = '<td';
t_player_end = '</td>';
t_name_sta = "<a href=" + wildcardPattern + ">";
t_name_end = '</a>';
t_name_list = '';
t_result_list = '';

%% urlのサイトのhtml取得
try
    t_html = webread(a_url);
catch
    disp(PRV_DEF_FAIL_READ_URL());
    return;
end

%% 打者成績の表を取得
try
    t_butter_list = extractBetween(t_html, t_butterTbl_sta, t_butterTbl_end);
catch
    disp(PRV_DEF_FAIL_GET_BUTTER());
    return;
end

%% 打者成績表を作成
for t_player_idx = 1:size(t_butter_list,1)
    try
        % 打者名を取得
        t_name_element = extractBetween(t_butter_list{t_player_idx,1}, t_name_sta, t_name_end);
        t_name_list = vertcat(t_name_list, transpose(t_name_element));
        % 打者成績要素を取得
        t_result_element = extractBetween(t_butter_list{t_player_idx,1}, t_player_sta, t_player_end);
        t_result_list = vertcat(t_result_list, transpose(t_result_element));
        % 打者名と打者成績を結合
        t_butter_table = horzcat(t_name_list, t_result_list);
    catch
        disp(PRV_DEF_FAIL_MAKE_BUTTER_RESULT());
        return;
    end
end

r_ret = 0;
return
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 例外メッセージ
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% urlの取得に失敗
function r_ret = PRV_DEF_FAIL_READ_URL()
r_ret = 'error: URLの読み込みに失敗しました。';
end

% 打者成績の取得に失敗
function r_ret = PRV_DEF_FAIL_GET_BUTTER()
r_ret = 'error: 打者成績の取得に失敗しました。';
end

% 打者成績表の作成に失敗
function r_ret = PRV_DEF_FAIL_MAKE_BUTTER_RESULT()
r_ret = 'error: 打者成績表の作成に失敗しました。';
end
