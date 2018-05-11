From: Vivek Goyal <vgoyal@redhat.com>
Subject: Re: [PATCH v2 22/35] vfs: don't open real
Date: Fri, 11 May 2018 14:54:30 -0400
Message-ID: <20180511185430.GE6044@redhat.com>
References: <20180507083807.28792-1-mszeredi@redhat.com>
 <20180507083807.28792-23-mszeredi@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180507083807.28792-23-mszeredi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Miklos Szeredi <mszeredi@redhat.com>
Cc: linux-unionfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, Al Viro <viro@zeniv.linux.org.uk>, linux-security-module@vger.kernel.org, Daniel J Walsh <dwalsh@redhat.com>, Paul Moore <pmoore@redhat.com>, Stephen Smalley <sds@tycho.nsa.gov>
List-Id: linux-unionfs@vger.kernel.org

On Mon, May 07, 2018 at 10:37:54AM +0200, Miklos Szeredi wrote:
> Let overlayfs do its thing when opening a file.
> 
> This enables stacking and fixes the corner case when a file is opened for
> read, modified through a writable open, and data is read from the read-only
> file.  After this patch the read-only open will not return stale data even
> in this case.

[CC Dan, Steven, Paul, linux-security-module list]

Hi Miklos,

I was running selinux-testsuite and one of the tests seems to fail. I
think this is side effect of installing overlay inode in file->f_inode
instead of real underlying inode.

Following test is failing.

sub test_90_1 {
    print "Attempting to enter domain with bad entrypoint, should fail.\n";
    $result = system(
"runcon -t test_overlay_client_t -l s0:c10,c20 $basedir/container1/merged/badentrypoint >/dev/null 2>&1"
    );
    ok($result);
    return;
}

Basically, this test has an executable named "badentrypoint" with selinux
label "unconfined_u:object_r:test_overlay_files_ro_t:s0". And we mount
overlay with context=unconfined_u:object_r:test_overlay_files_rwx_t:s0:c10,c20

So effectively overlay inode of "badentrypoint" now gets the label
specified by "context=".

I think intent of test is that this file's real label is "...ro_t". That
means this file is not supposed to be executed and any attempt to execute
it should be denied.

Currently test works and execution fails with following avc.

AVC avc:  denied  { entrypoint } for  pid=1425 comm="runcon" path="/root/git/selinux-testsuite/tests/overlay/container1/merged/badentrypoint" dev="dm-0" ino=34515261 scontext=unconfined_u:unconfined_r:test_overlay_client_t:s0:c10,c20 tcontext=unconfined_u:object_r:test_overlay_files_ro_t:s0 tclass=file permissive=0

But with new patches, this test starts passing. 

I think currently selinux_bprm_set_creds() returns error. It does
checks on inode returned by file_inode() and as of now that inode is
real inode and that inode has real lable of "...ro_t" and permission
to execute that file is denied.

But after the patches file_inode() returns overlay inode. Which has
the label specified by context= mount option "...rwx_t". And that
label allows executing file, so file execution is not blocked by
selinux.

I feel that even now code is working accidently. Ideally our theme was
that task's credential as checked against overlay inode and mounter's
creds are checked against underlying inode to determine if certain
permission is allowed. So ideally mounter should not have been allwed
to execute a file of type "...ro_t". But we don't have that workflow
and VFS calls into selinux and selinux checks the underlying file's
label against task.

It worked so far but the moment we install overlay inode in file, selinux
checks it against overlay inode label and allows permission to execute and
mounter is never checked against real inode.

I am not sure what's the right solution. So far selinux is not aware of
two levels of checks and if two levels of checks are to be performed, it
somehow needs to be enforced by overlay and call same hook on two levels.

Thought of atleast starting a conversation on this.

Thanks
Vivek


> 
> Signed-off-by: Miklos Szeredi <mszeredi@redhat.com>
> ---
>  fs/open.c | 7 +------
>  1 file changed, 1 insertion(+), 6 deletions(-)
> 
> diff --git a/fs/open.c b/fs/open.c
> index 6e52fd6fea7c..244cd2ecfefd 100644
> --- a/fs/open.c
> +++ b/fs/open.c
> @@ -897,13 +897,8 @@ EXPORT_SYMBOL(file_path);
>  int vfs_open(const struct path *path, struct file *file,
>  	     const struct cred *cred)
>  {
> -	struct dentry *dentry = d_real(path->dentry, NULL, file->f_flags, 0);
> -
> -	if (IS_ERR(dentry))
> -		return PTR_ERR(dentry);
> -
>  	file->f_path = *path;
> -	return do_dentry_open(file, d_backing_inode(dentry), NULL, cred);
> +	return do_dentry_open(file, d_backing_inode(path->dentry), NULL, cred);
>  }
>  
>  /**
> -- 
> 2.14.3
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-unionfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
