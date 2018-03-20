From: "=?UTF-8?B?546L5YWD6Imv?=" <yuanliang.wyl@alibaba-inc.com>
Subject: [PATCH] fs/overlayfs: Drop dentry cache to prevent unknown file status
Date: Tue, 20 Mar 2018 14:03:50 +0800
Message-ID: <1521525830-88382-1-git-send-email-yuanliang.wyl@alibaba-inc.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: miklos@szeredi.hu
Cc: linux-unionfs@vger.kernel.org, linux-kernel@vger.kernel.org, =?UTF-8?B?546L5YWD6Imv?= <yuanliang.wyl@alibaba-inc.com>
List-Id: linux-unionfs@vger.kernel.org

When the dentry cache is not destroyed, statfs will
take unknown status '?'
Undestroyed cache dentry also caused new file creating fails

Drop it using d_delete may be a choice

[root@host /]
Loaded plugins: bestyumcache, branch, fastestmirror, langpacks
Repodata is over 2 weeks old. Install yum-cron? Or run: yum makecache
fast
Cleaning repos: xxx.base.x86_64 ops.x.noarch ops.x.x86_64
Cleaning up everything
Cleaning up list of best yumcache
Cleaning up list of fastest mirrors

[root@host /]
Loaded plugins: bestyumcache, branch, fastestmirror, langpacks
Cleaning repos: xxx.base.x86_64 ops.x.noarch ops.x.x86_64
Cleaning up everything
Cleaning up list of best yumcache
Traceback (most recent call last):
    File "/usr/bin/yum", line 29, in <module>
    yummain.user_main(sys.argv[1:], exit_code=True)
    File "/usr/share/yum-cli/yummain.py", line 365, in user_main
    errcode = main(args)
    File "/usr/share/yum-cli/yummain.py", line 174, in main
    result, resultmsgs = base.doCommands()
    File "/usr/share/yum-cli/cli.py", line 573, in doCommands
    return self.yum_cli_commands[self.basecmd].doCommand(self,
	    self.basecmd, self.extcmds)
	   File "/usr/share/yum-cli/yumcommands.py", line
    1475, in doCommand
    return base.cleanCli(extcmds)
    File "/usr/share/yum-cli/cli.py", line 1666, in
    cleanCli
    self.plugins.run('clean')
    File
    "/usr/lib/python2.7/site-packages/yum/plugins.py", line 188, in run
    func(conduitcls(self, self.base, conf, **kwargs))
    File "/usr/lib/yum-plugins/branch.py", line 65, in clean_hook
    os.remove(os.path.join(root,filespath))
    OSError: [Errno 2] No such file or directory:
	      '/var/cache/yum/x86_64/x/xxxx.noarch.stable/
	     b49e49b87d17818d799363091c7a01dde83b421d-primary.sqlite.bz2'

[root@host /]
    ls: cannot access
    /var/cache/yum/x86_64/x/xxxx.noarch.stable/
    b49e49b87d17818d799363091c7a01dde83b421d-primary.sqlite.bz2:
    No such file or directory
    ls: cannot access
    /var/cache/yum/x86_64/x/xxxx.noarch.stable/cachecookie:
    No such file or directory
    ls: cannot access
    /var/cache/yum/x86_64/x/xxxx.noarch.stable/repomd.xml:
    No such file or directory
    total 0
    ?????????? ? ?    ?     ?            ?
    b49e49b87d17818d799363091c7a01dde83b421d-primary.sqlite.bz2
    ?????????? ? ?    ?     ?            ?
    cachecookie
    drwxr-xr-x 1 root root 30 Mar 15 16:12 gen
    drwxr-xr-x 2 root root  6 Jan 31 13:13
    packages
    ?????????? ? ?    ?     ?            ?
    repomd.xml

Signed-off-by: Yuanliang Wang <yuanliang.wyl@alibaba-inc.com>
---
 fs/overlayfs/super.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/fs/overlayfs/super.c b/fs/overlayfs/super.c
index e7c8ac4..f9343d3 100644
--- a/fs/overlayfs/super.c
+++ b/fs/overlayfs/super.c
@@ -380,9 +380,15 @@ static int ovl_dentry_weak_revalidate(struct dentry *dentry, unsigned int flags)
 	return ret;
 }
 
+static int ovl_dentry_delete(const struct dentry *dentry)
+{
+	return 1;
+}
+
 static const struct dentry_operations ovl_dentry_operations = {
 	.d_release = ovl_dentry_release,
 	.d_real = ovl_d_real,
+	.d_delete = ovl_dentry_delete,
 };
 
 static const struct dentry_operations ovl_reval_dentry_operations = {
-- 
1.8.3.1
