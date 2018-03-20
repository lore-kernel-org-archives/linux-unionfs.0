Return-Path: <cgxu519@gmx.com>
MIME-Version: 1.0
Message-ID: <trinity-306a18e4-6e8d-41e3-b43b-2156bf9166e5-1521531446824@3c-app-mailcom-bs12>
From: "Chengguang Xu" <cgxu519@gmx.com>
Subject: =?UTF-8?Q?Re=3A_=E5=9B=9E=E5=A4=8D=EF=BC=9A=5BPATCH=5D_fs/o?=
 =?UTF-8?Q?verlayfs=3A_Drop_dent?=
 =?UTF-8?Q?ry_cache_to_prevent_unknown_file_status?=
Content-Type: text/html; charset=UTF-8
Date: Tue, 20 Mar 2018 08:37:26 +0100
In-Reply-To: <d4e3461e-7a46-41dd-a27b-d86a5c5144b9.yuanliang.wyl@alibaba-inc.com>
References: <1521525830-88382-1-git-send-email-yuanliang.wyl@alibaba-inc.com>
 <trinity-46014179-644f-4087-8f6b-614fa55fca2a-1521528270006@3c-app-mailcom-bs12>
 <trinity-f09d5d8a-6967-4254-88db-cf7ea9270afe-1521529654015@3c-app-mailcom-bs12>
 <d4e3461e-7a46-41dd-a27b-d86a5c5144b9.yuanliang.wyl@alibaba-inc.com>
To: yuanliang.wyl@alibaba-inc.com
Cc: miklos <miklos@szeredi.hu>, linux-unionfs <linux-unionfs@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>
List-ID: <linux-unionfs@vger.kernel.org>

<html><head></head><body><div style="font-family: Verdana;font-size: 12.0px;"><div>
<div>Hi Yuanliang,</div>

<div>&nbsp;</div>

<div>
<div>If you use ext4, you can try below command to check if filetype</div>

<div>feature has already enabled.</div>

<div>&nbsp;</div>

<div>tune2fs -l /dev/xxx &#124; grep feature</div>

<div>&nbsp;</div>

<div>If filetype feature is not enabled, please enable it first and</div>

<div>check if the problem still persist.</div>

<div>&nbsp;</div>

<div>The phenomenon I met is similar to yours in the previous email.</div>

<div>&nbsp;</div>

<div>Thanks,</div>

<div>Chengguang.</div>

<div>&nbsp;</div>

<div>&nbsp;</div>

<div name="quote" style="margin:10px 5px 5px 10px; padding: 10px 0 10px 10px; border-left:2px solid #C3D9E5; word-wrap: break-word; -webkit-nbsp-mode: space; -webkit-line-break: after-white-space;">
<div style="margin:0 0 10px 0;"><b>Sent:</b>&nbsp;Tuesday, March 20, 2018 at 3:22 PM<br/>
<b>From:</b>&nbsp;&#29579;&#20803;&#33391; &lt;yuanliang.wyl@alibaba-inc.com&gt;<br/>
<b>To:</b>&nbsp;&quot;Chengguang Xu&quot; &lt;cgxu519@gmx.com&gt;, &quot;Chengguang Xu&quot; &lt;cgxu519@gmx.com&gt;<br/>
<b>Cc:</b>&nbsp;miklos &lt;miklos@szeredi.hu&gt;, linux-unionfs &lt;linux-unionfs@vger.kernel.org&gt;, linux-kernel &lt;linux-kernel@vger.kernel.org&gt;<br/>
<b>Subject:</b>&nbsp;&#22238;&#22797;&#65306;[PATCH] fs/overlayfs: Drop dentry cache to prevent unknown file status</div>

<div name="quoted-content">
<div class="__aliyun_email_body_block">
<div style="line-height: 1.7;font-family: Tahoma , Arial , STHeiti , SimSun;font-size: 14.0px;color: rgb(0,0,0);">
<div style="clear: both;">Hi, Chengguang</div>

<div style="clear: both;">&nbsp;</div>

<div style="clear: both;">is the ftype for xfs only?</div>

<div style="clear: both;">&nbsp;</div>

<div style="clear: both;">Could you&nbsp;describe&nbsp;in&nbsp;detail&nbsp;the&nbsp;problems&nbsp;that&nbsp;you&nbsp;have&nbsp;encountered&nbsp;on&nbsp;your&nbsp;side&nbsp;and&nbsp;give&nbsp;more&nbsp;on-site&nbsp;information&nbsp;may&nbsp;help?</div>

<div class="clear: both">&nbsp;</div>

<blockquote style="margin-right: 0;margin-top: 0;margin-bottom: 0;font-family: Tahoma , Arial , STHeiti , SimSun;font-size: 14.0px;color: rgb(0,0,0);">
<div class="clear: both">------------------------------------------------------------------</div>

<div class="clear: both">&#21457;&#20214;&#20154;&#65306;Chengguang Xu &lt;cgxu519@gmx.com&gt;</div>

<div class="clear: both">&#21457;&#36865;&#26102;&#38388;&#65306;2018&#24180;3&#26376;20&#26085;(&#26143;&#26399;&#20108;) 15:07</div>

<div class="clear: both">&#25910;&#20214;&#20154;&#65306;Chengguang Xu &lt;cgxu519@gmx.com&gt;</div>

<div class="clear: both">&#25220;&#12288;&#36865;&#65306;&#29579;&#20803;&#33391;(&#23561;&#29313;) &lt;yuanliang.wyl@alibaba-inc.com&gt;; miklos &lt;miklos@szeredi.hu&gt;; linux-unionfs &lt;linux-unionfs@vger.kernel.org&gt;; linux-kernel &lt;linux-kernel@vger.kernel.org&gt;</div>

<div class="clear: both">&#20027;&#12288;&#39064;&#65306;Re: [PATCH] fs/overlayfs: Drop dentry cache to prevent unknown file status</div>

<div class="clear: both">&nbsp;</div>
Hi&nbsp;Yuanliang,<br/>
<br/>
Can&nbsp;you&nbsp;try&nbsp;ext4&nbsp;or&nbsp;xfs(with&nbsp;ftype=1)&nbsp;as&nbsp;underlying&nbsp;fs?&nbsp;<br/>
It&nbsp;seems&nbsp;the&nbsp;phenomenon&nbsp;that&nbsp;I&nbsp;met&nbsp;on&nbsp;xfs(with&nbsp;ftype=0)&nbsp;as&nbsp;underlying&nbsp;fs.<br/>
Thanks,<br/>
Chengguang.<br/>
<br/>
<br/>
&gt;&nbsp;Sent:&nbsp;Tuesday,&nbsp;March&nbsp;20,&nbsp;2018&nbsp;at&nbsp;2:44&nbsp;PM<br/>
&gt;&nbsp;From:&nbsp;&quot;Chengguang&nbsp;Xu&quot;&nbsp;&lt;cgxu519@gmx.com&gt;<br/>
&gt;&nbsp;To:&nbsp;&#29579;&#20803;&#33391;&nbsp;&lt;yuanliang.wyl@alibaba-inc.com&gt;<br/>
&gt;&nbsp;Cc:&nbsp;miklos@szeredi.hu,&nbsp;linux-unionfs@vger.kernel.org,&nbsp;linux-kernel@vger.kernel.org,&nbsp;&#29579;&#20803;&#33391;&nbsp;&lt;yuanliang.wyl@alibaba-inc.com&gt;<br/>
&gt;&nbsp;Subject:&nbsp;Re:&nbsp;[PATCH]&nbsp;fs/overlayfs:&nbsp;Drop&nbsp;dentry&nbsp;cache&nbsp;to&nbsp;prevent&nbsp;unknown&nbsp;file&nbsp;status<br/>
&gt;<br/>
&gt;&nbsp;Hi&nbsp;Yuanliang,<br/>
&gt;&nbsp;<br/>
&gt;&nbsp;Can&nbsp;you&nbsp;explain&nbsp;how&nbsp;to&nbsp;reproduce&nbsp;it?&nbsp;and&nbsp;what&nbsp;filesystem&nbsp;do&nbsp;you&nbsp;use&nbsp;as&nbsp;underlying&nbsp;fs?<br/>
&gt;&nbsp;<br/>
&gt;&nbsp;<br/>
&gt;&nbsp;&gt;&nbsp;Sent:&nbsp;Tuesday,&nbsp;March&nbsp;20,&nbsp;2018&nbsp;at&nbsp;2:03&nbsp;PM<br/>
&gt;&nbsp;&gt;&nbsp;From:&nbsp;&#29579;&#20803;&#33391;&nbsp;&lt;yuanliang.wyl@alibaba-inc.com&gt;<br/>
&gt;&nbsp;&gt;&nbsp;To:&nbsp;miklos@szeredi.hu<br/>
&gt;&nbsp;&gt;&nbsp;Cc:&nbsp;linux-unionfs@vger.kernel.org,&nbsp;linux-kernel@vger.kernel.org,&nbsp;&#29579;&#20803;&#33391;&nbsp;&lt;yuanliang.wyl@alibaba-inc.com&gt;<br/>
&gt;&nbsp;&gt;&nbsp;Subject:&nbsp;[PATCH]&nbsp;fs/overlayfs:&nbsp;Drop&nbsp;dentry&nbsp;cache&nbsp;to&nbsp;prevent&nbsp;unknown&nbsp;file&nbsp;status<br/>
&gt;&nbsp;&gt;<br/>
&gt;&nbsp;&gt;&nbsp;When&nbsp;the&nbsp;dentry&nbsp;cache&nbsp;is&nbsp;not&nbsp;destroyed,&nbsp;statfs&nbsp;will<br/>
&gt;&nbsp;&gt;&nbsp;take&nbsp;unknown&nbsp;status&nbsp;&#39;?&#39;<br/>
&gt;&nbsp;&gt;&nbsp;Undestroyed&nbsp;cache&nbsp;dentry&nbsp;also&nbsp;caused&nbsp;new&nbsp;file&nbsp;creating&nbsp;fails<br/>
&gt;&nbsp;&gt;&nbsp;<br/>
&gt;&nbsp;&gt;&nbsp;Drop&nbsp;it&nbsp;using&nbsp;d_delete&nbsp;may&nbsp;be&nbsp;a&nbsp;choice<br/>
&gt;&nbsp;&gt;&nbsp;<br/>
&gt;&nbsp;&gt;&nbsp;[root@host&nbsp;/]<br/>
&gt;&nbsp;&gt;&nbsp;Loaded&nbsp;plugins:&nbsp;bestyumcache,&nbsp;branch,&nbsp;fastestmirror,&nbsp;langpacks<br/>
&gt;&nbsp;&gt;&nbsp;Repodata&nbsp;is&nbsp;over&nbsp;2&nbsp;weeks&nbsp;old.&nbsp;Install&nbsp;yum-cron?&nbsp;Or&nbsp;run:&nbsp;yum&nbsp;makecache<br/>
&gt;&nbsp;&gt;&nbsp;fast<br/>
&gt;&nbsp;&gt;&nbsp;Cleaning&nbsp;repos:&nbsp;xxx.base.x86_64&nbsp;ops.x.noarch&nbsp;ops.x.x86_64<br/>
&gt;&nbsp;&gt;&nbsp;Cleaning&nbsp;up&nbsp;everything<br/>
&gt;&nbsp;&gt;&nbsp;Cleaning&nbsp;up&nbsp;list&nbsp;of&nbsp;best&nbsp;yumcache<br/>
&gt;&nbsp;&gt;&nbsp;Cleaning&nbsp;up&nbsp;list&nbsp;of&nbsp;fastest&nbsp;mirrors<br/>
&gt;&nbsp;&gt;&nbsp;<br/>
&gt;&nbsp;&gt;&nbsp;[root@host&nbsp;/]<br/>
&gt;&nbsp;&gt;&nbsp;Loaded&nbsp;plugins:&nbsp;bestyumcache,&nbsp;branch,&nbsp;fastestmirror,&nbsp;langpacks<br/>
&gt;&nbsp;&gt;&nbsp;Cleaning&nbsp;repos:&nbsp;xxx.base.x86_64&nbsp;ops.x.noarch&nbsp;ops.x.x86_64<br/>
&gt;&nbsp;&gt;&nbsp;Cleaning&nbsp;up&nbsp;everything<br/>
&gt;&nbsp;&gt;&nbsp;Cleaning&nbsp;up&nbsp;list&nbsp;of&nbsp;best&nbsp;yumcache<br/>
&gt;&nbsp;&gt;&nbsp;Traceback&nbsp;(most&nbsp;recent&nbsp;call&nbsp;last):<br/>
&gt;&nbsp;&gt;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;File&nbsp;&quot;/usr/bin/yum&quot;,&nbsp;line&nbsp;29,&nbsp;in&nbsp;&lt;module&gt;<br/>
&gt;&nbsp;&gt;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;yummain.user_main(sys.argv[1:],&nbsp;exit_code=True)<br/>
&gt;&nbsp;&gt;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;File&nbsp;&quot;/usr/share/yum-cli/yummain.py&quot;,&nbsp;line&nbsp;365,&nbsp;in&nbsp;user_main<br/>
&gt;&nbsp;&gt;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;errcode&nbsp;=&nbsp;main(args)<br/>
&gt;&nbsp;&gt;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;File&nbsp;&quot;/usr/share/yum-cli/yummain.py&quot;,&nbsp;line&nbsp;174,&nbsp;in&nbsp;main<br/>
&gt;&nbsp;&gt;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;result,&nbsp;resultmsgs&nbsp;=&nbsp;base.doCommands()<br/>
&gt;&nbsp;&gt;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;File&nbsp;&quot;/usr/share/yum-cli/cli.py&quot;,&nbsp;line&nbsp;573,&nbsp;in&nbsp;doCommands<br/>
&gt;&nbsp;&gt;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;return&nbsp;self.yum_cli_commands[self.basecmd].doCommand(self,<br/>
&gt;&nbsp;&gt;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;self.basecmd,&nbsp;self.extcmds)<br/>
&gt;&nbsp;&gt;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;File&nbsp;&quot;/usr/share/yum-cli/yumcommands.py&quot;,&nbsp;line<br/>
&gt;&nbsp;&gt;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;1475,&nbsp;in&nbsp;doCommand<br/>
&gt;&nbsp;&gt;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;return&nbsp;base.cleanCli(extcmds)<br/>
&gt;&nbsp;&gt;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;File&nbsp;&quot;/usr/share/yum-cli/cli.py&quot;,&nbsp;line&nbsp;1666,&nbsp;in<br/>
&gt;&nbsp;&gt;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;cleanCli<br/>
&gt;&nbsp;&gt;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;self.plugins.run(&#39;clean&#39;)<br/>
&gt;&nbsp;&gt;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;File<br/>
&gt;&nbsp;&gt;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&quot;/usr/lib/python2.7/site-packages/yum/plugins.py&quot;,&nbsp;line&nbsp;188,&nbsp;in&nbsp;run<br/>
&gt;&nbsp;&gt;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;func(conduitcls(self,&nbsp;self.base,&nbsp;conf,&nbsp;**kwargs))<br/>
&gt;&nbsp;&gt;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;File&nbsp;&quot;/usr/lib/yum-plugins/branch.py&quot;,&nbsp;line&nbsp;65,&nbsp;in&nbsp;clean_hook<br/>
&gt;&nbsp;&gt;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;os.remove(os.path.join(root,filespath))<br/>
&gt;&nbsp;&gt;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;OSError:&nbsp;[Errno&nbsp;2]&nbsp;No&nbsp;such&nbsp;file&nbsp;or&nbsp;directory:<br/>
&gt;&nbsp;&gt;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&#39;/var/cache/yum/x86_64/x/xxxx.noarch.stable/<br/>
&gt;&nbsp;&gt;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;b49e49b87d17818d799363091c7a01dde83b421d-primary.sqlite.bz2&#39;<br/>
&gt;&nbsp;&gt;&nbsp;<br/>
&gt;&nbsp;&gt;&nbsp;[root@host&nbsp;/]<br/>
&gt;&nbsp;&gt;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;ls:&nbsp;cannot&nbsp;access<br/>
&gt;&nbsp;&gt;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;/var/cache/yum/x86_64/x/xxxx.noarch.stable/<br/>
&gt;&nbsp;&gt;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;b49e49b87d17818d799363091c7a01dde83b421d-primary.sqlite.bz2:<br/>
&gt;&nbsp;&gt;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;No&nbsp;such&nbsp;file&nbsp;or&nbsp;directory<br/>
&gt;&nbsp;&gt;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;ls:&nbsp;cannot&nbsp;access<br/>
&gt;&nbsp;&gt;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;/var/cache/yum/x86_64/x/xxxx.noarch.stable/cachecookie:<br/>
&gt;&nbsp;&gt;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;No&nbsp;such&nbsp;file&nbsp;or&nbsp;directory<br/>
&gt;&nbsp;&gt;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;ls:&nbsp;cannot&nbsp;access<br/>
&gt;&nbsp;&gt;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;/var/cache/yum/x86_64/x/xxxx.noarch.stable/repomd.xml:<br/>
&gt;&nbsp;&gt;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;No&nbsp;such&nbsp;file&nbsp;or&nbsp;directory<br/>
&gt;&nbsp;&gt;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;total&nbsp;0<br/>
&gt;&nbsp;&gt;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;??????????&nbsp;?&nbsp;?&nbsp;&nbsp;&nbsp;&nbsp;?&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;?&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;?<br/>
&gt;&nbsp;&gt;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;b49e49b87d17818d799363091c7a01dde83b421d-primary.sqlite.bz2<br/>
&gt;&nbsp;&gt;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;??????????&nbsp;?&nbsp;?&nbsp;&nbsp;&nbsp;&nbsp;?&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;?&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;?<br/>
&gt;&nbsp;&gt;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;cachecookie<br/>
&gt;&nbsp;&gt;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;drwxr-xr-x&nbsp;1&nbsp;root&nbsp;root&nbsp;30&nbsp;Mar&nbsp;15&nbsp;16:12&nbsp;gen<br/>
&gt;&nbsp;&gt;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;drwxr-xr-x&nbsp;2&nbsp;root&nbsp;root&nbsp;&nbsp;6&nbsp;Jan&nbsp;31&nbsp;13:13<br/>
&gt;&nbsp;&gt;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;packages<br/>
&gt;&nbsp;&gt;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;??????????&nbsp;?&nbsp;?&nbsp;&nbsp;&nbsp;&nbsp;?&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;?&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;?<br/>
&gt;&nbsp;&gt;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;repomd.xml<br/>
&gt;&nbsp;&gt;&nbsp;<br/>
&gt;&nbsp;&gt;&nbsp;Signed-off-by:&nbsp;Yuanliang&nbsp;Wang&nbsp;&lt;yuanliang.wyl@alibaba-inc.com&gt;<br/>
&gt;&nbsp;&gt;&nbsp;---<br/>
&gt;&nbsp;&gt;&nbsp;&nbsp;fs/overlayfs/super.c&nbsp;&#124;&nbsp;6&nbsp;++++++<br/>
&gt;&nbsp;&gt;&nbsp;&nbsp;1&nbsp;file&nbsp;changed,&nbsp;6&nbsp;insertions(+)<br/>
&gt;&nbsp;&gt;&nbsp;<br/>
&gt;&nbsp;&gt;&nbsp;diff&nbsp;--git&nbsp;a/fs/overlayfs/super.c&nbsp;b/fs/overlayfs/super.c<br/>
&gt;&nbsp;&gt;&nbsp;index&nbsp;e7c8ac4..f9343d3&nbsp;100644<br/>
&gt;&nbsp;&gt;&nbsp;---&nbsp;a/fs/overlayfs/super.c<br/>
&gt;&nbsp;&gt;&nbsp;+++&nbsp;b/fs/overlayfs/super.c<br/>
&gt;&nbsp;&gt;&nbsp;@@&nbsp;-380,9&nbsp;+380,15&nbsp;@@&nbsp;static&nbsp;int&nbsp;ovl_dentry_weak_revalidate(struct&nbsp;dentry&nbsp;*dentry,&nbsp;unsigned&nbsp;int&nbsp;flags)<br/>
&gt;&nbsp;&gt;&nbsp;&nbsp;&nbsp;return&nbsp;ret;<br/>
&gt;&nbsp;&gt;&nbsp;&nbsp;}<br/>
&gt;&nbsp;&gt;&nbsp;&nbsp;<br/>
&gt;&nbsp;&gt;&nbsp;+static&nbsp;int&nbsp;ovl_dentry_delete(const&nbsp;struct&nbsp;dentry&nbsp;*dentry)<br/>
&gt;&nbsp;&gt;&nbsp;+{<br/>
&gt;&nbsp;&gt;&nbsp;+&nbsp;return&nbsp;1;<br/>
&gt;&nbsp;&gt;&nbsp;+}<br/>
&gt;&nbsp;&gt;&nbsp;+<br/>
&gt;&nbsp;&gt;&nbsp;&nbsp;static&nbsp;const&nbsp;struct&nbsp;dentry_operations&nbsp;ovl_dentry_operations&nbsp;=&nbsp;{<br/>
&gt;&nbsp;&gt;&nbsp;&nbsp;&nbsp;.d_release&nbsp;=&nbsp;ovl_dentry_release,<br/>
&gt;&nbsp;&gt;&nbsp;&nbsp;&nbsp;.d_real&nbsp;=&nbsp;ovl_d_real,<br/>
&gt;&nbsp;&gt;&nbsp;+&nbsp;.d_delete&nbsp;=&nbsp;ovl_dentry_delete,<br/>
&gt;&nbsp;&gt;&nbsp;&nbsp;};<br/>
&gt;&nbsp;&gt;&nbsp;&nbsp;<br/>
&gt;&nbsp;&gt;&nbsp;&nbsp;static&nbsp;const&nbsp;struct&nbsp;dentry_operations&nbsp;ovl_reval_dentry_operations&nbsp;=&nbsp;{<br/>
&gt;&nbsp;&gt;&nbsp;--&nbsp;<br/>
&gt;&nbsp;&gt;&nbsp;1.8.3.1<br/>
&gt;&nbsp;&gt;&nbsp;<br/>
&gt;&nbsp;&gt;&nbsp;--<br/>
&gt;&nbsp;&gt;&nbsp;To&nbsp;unsubscribe&nbsp;from&nbsp;this&nbsp;list:&nbsp;send&nbsp;the&nbsp;line&nbsp;&quot;unsubscribe&nbsp;linux-unionfs&quot;&nbsp;in<br/>
&gt;&nbsp;&gt;&nbsp;the&nbsp;body&nbsp;of&nbsp;a&nbsp;message&nbsp;to&nbsp;majordomo@vger.kernel.org<br/>
&gt;&nbsp;&gt;&nbsp;More&nbsp;majordomo&nbsp;info&nbsp;at&nbsp;&nbsp;http://vger.kernel.org/majordomo-info.html<br/>
&gt;&nbsp;&gt;<br/>
&gt;&nbsp;--<br/>
&gt;&nbsp;To&nbsp;unsubscribe&nbsp;from&nbsp;this&nbsp;list:&nbsp;send&nbsp;the&nbsp;line&nbsp;&quot;unsubscribe&nbsp;linux-unionfs&quot;&nbsp;in<br/>
&gt;&nbsp;the&nbsp;body&nbsp;of&nbsp;a&nbsp;message&nbsp;to&nbsp;majordomo@vger.kernel.org<br/>
&gt;&nbsp;More&nbsp;majordomo&nbsp;info&nbsp;at&nbsp;&nbsp;http://vger.kernel.org/majordomo-info.html<br/>
&gt;</blockquote>
</div>
</div>
</div>
</div>
</div>
</div></div></body></html>
