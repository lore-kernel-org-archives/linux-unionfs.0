From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: [PATCH 07/12] vfs: do get_write_access() on upper layer of overlayfs
Date: Wed, 19 Oct 2016 10:41:23 +0300
Message-ID: <CAOQ4uxj5QxcGRMGT78qQf0vmjjP2Do8uaOX-B31HYXt-Wz3Fjg@mail.gmail.com>
References: <1474028371-21288-1-git-send-email-mszeredi@redhat.com>
 <1474028371-21288-8-git-send-email-mszeredi@redhat.com> <CAOQ4uxju-nD7PLtpPv8yCaN7WHPG9SPM+oaQcthv2ECqJFtKdw@mail.gmail.com>
 <CAJfpegu8dfSzKpvA5g+jPdUXxhuQwNd=TDaH6xDR2ZYt_V6QZQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <CAJfpegu8dfSzKpvA5g+jPdUXxhuQwNd=TDaH6xDR2ZYt_V6QZQ@mail.gmail.com>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Miklos Szeredi <mszeredi@redhat.com>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Al Viro <viro@zeniv.linux.org.uk>, "J. Bruce Fields" <bfields@fieldses.org>, "linux-unionfs@vger.kernel.org" <linux-unionfs@vger.kernel.org>
List-Id: linux-unionfs@vger.kernel.org

On Tue, Oct 18, 2016 at 10:53 PM, Miklos Szeredi <miklos@szeredi.hu> wrote:
> On Tue, Oct 18, 2016 at 9:41 PM, Amir Goldstein <amir73il@gmail.com> wrote:
>> On Fri, Sep 16, 2016 at 3:19 PM, Miklos Szeredi <mszeredi@redhat.com> wrote:
>>> The problem with writecount is: we want consistent handling of it for
>>> underlying filesystems as well as overlayfs.  Making sure i_writecount is
>>> correct on all layers is difficult.  Instead this patch makes sure that
>>> when write access is acquired, it's always done on the underlying writable
>>> layer (called the upper layer).  We must also make sure to look at the
>>> writecount on this layer when checking for conflicting leases.
>>>
>>> Open for write already updates the upper layer's writecount.  Leaving only
>>> truncate.
>>>
>>> For truncate copy up must happen before get_write_access() so that the
>>> writecount is updated on the upper layer.  Problem with this is if
>>> something fails after that, then copy-up was done needlessly.  E.g. if
>>> break_lease() was interrupted.  Probably not a big deal in practice.
>>>
>>> Another interesting case is if there's a denywrite on a lower file that is
>>> then opened for write or truncated.  With this patch these will succeed,
>>> which is somewhat counterintuitive.  But I think it's still acceptable,
>>> considering that the copy-up does actually create a different file, so the
>>> old, denywrite mapping won't be touched.
>>
>> Miklos,
>> I think this breaks xfstest overlay/013 on v4.8, because execve() does
>> deny write on lower inode and then truncate happens on upper inode.
>
> It does break the xfstest, but as explained in the patch it shouldn't
> be a problem in practice.  I think the test should just be fixed.
>

Right. and so I did fix the test, which had a bug anyway and was not
testing exec+truncate from upper at all.

But I noticed a strange behavior:
When you run t_truncate_self from upper you get success for not being
able to truncate.
When you run t_truncate_self from lower you get an error for being
able to truncate
This is ok as you write, but...
When you re-run t_truncate_self file that just got copied-up you get
segmentation fault
and that is not ok.

You get try the patch to xfstest below to reproduce the problem:

diff --git a/tests/overlay/013 b/tests/overlay/013
index 09f3eb1..cd3d0c0 100755
--- a/tests/overlay/013
+++ b/tests/overlay/013
@@ -59,7 +59,7 @@ upperdir=$SCRATCH_DEV/$OVERLAY_UPPER_DIR
 mkdir -p $lowerdir
 mkdir -p $upperdir
 cp $here/src/t_truncate_self $lowerdir/test_lower
-cp $here/src/t_truncate_self $lowerdir/test_upper
+cp $here/src/t_truncate_self $upperdir/test_upper

 _scratch_mount

@@ -67,8 +67,9 @@ _scratch_mount
 # test programs truncate themselfs, all should fail with ETXTBSY
 $SCRATCH_MNT/test_lower
 $SCRATCH_MNT/test_upper
+# run test again after copy-up
+$SCRATCH_MNT/test_lower

 # success, all done
-echo "Silence is golden"
 status=0
 exit
diff --git a/tests/overlay/013.out b/tests/overlay/013.out
index 3e66423..a8ee7cd 100644
--- a/tests/overlay/013.out
+++ b/tests/overlay/013.out
@@ -1,2 +1,2 @@
 QA output created by 013
-Silence is golden
+truncate(argv[0]) should have failed
