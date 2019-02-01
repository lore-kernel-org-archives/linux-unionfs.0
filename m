Return-Path: <vgoyal@redhat.com>
Date: Fri, 1 Feb 2019 11:47:14 -0500
From: Vivek Goyal <vgoyal@redhat.com>
Subject: Re: [RFC][PATCH v2 0/5] Experiments with overlayfs filemap
Message-ID: <20190201164714.GB26780@redhat.com>
References: <CAOQ4uxhnFeL-pHY6AM8UWD9RDu-RN=xuM-RCoq5Mw_htUvHBFA@mail.gmail.com>
 <CAJfpegv_GkeGapuTGDMtF79GL1iZK5+HA_p1+OQpqXhZsrS4JQ@mail.gmail.com>
 <CAOQ4uxgcCdpYoAbo5mp5AvdW9B-ENAJXgQbOtjsQoHKjr_b8iA@mail.gmail.com>
 <CAJfpegu_w+xfONCDMoqtLs=r6J8DUBjTU_W=pchRK0URum8c+Q@mail.gmail.com>
 <CAOQ4uxj08PhC2+h1LL+iKrAGnKXvT-oYNkFOjUqHrnBf84DswA@mail.gmail.com>
 <CAJfpegv1J4TvmhUvogGUP5pOZNT+gnRr1ygjWnyt7M56dirP0A@mail.gmail.com>
 <CAOQ4uxjh4yieJaacbP+5JbRY+=LV4oJU+1JCGV4S+eLE7FEcAw@mail.gmail.com>
 <CAJfpegu98HhOpajUOEm3OXXXTR4kePK-X3_hZurfDd=u0eHC0g@mail.gmail.com>
 <CAOQ4uxg4vNVKbNQMVKoT9_+95ft42TVCMqRYAED=AAvUHZQ1Hg@mail.gmail.com>
 <CAJfpegvuHcWX6BW+4rkD9tw5Cuf4OQ7QYZd-7yu9EA8r7o=_vA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJfpegvuHcWX6BW+4rkD9tw5Cuf4OQ7QYZd-7yu9EA8r7o=_vA@mail.gmail.com>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Amir Goldstein <amir73il@gmail.com>, cgxu519 <cgxu519@gmx.com>, overlayfs <linux-unionfs@vger.kernel.org>
List-ID: <linux-unionfs@vger.kernel.org>

On Fri, Feb 01, 2019 at 05:24:26PM +0100, Miklos Szeredi wrote:
> On Fri, Feb 1, 2019 at 2:25 PM Amir Goldstein <amir73il@gmail.com> wrote:
> 
> > Wrong st_mtime/st_ctime:
> > generic/003 generic/080 generic/215
> 
> Fixed.  Albeit, I feel it's pretty hackish with various forms of
> ovl_copyattr sprinkled all over the place.  Need to think about proper
> management of attributes between upper and overlay inode.
> 
> >
> > EIO on clone/dedupe:
> > generic/303 generic/304
> >
> > Wrong st_blocks/fiemap:
> > generic/353 generic/392 generic/422
> 
> Hmm, generic/353 passes for me...
> 
> >
> > New lazy copy up semantics:
> > overlay/060
> 
> Need to fix the testcase?

This seems to fix xfstest overlay/060 for me.

Vivek

Subject: Fix metacopy test cases for data copy up on first read/write

Overlayfs might copy up data of file on first read/write of file (and
not necessarily upon open of file). So read few bytes from file opened
with O_RDWR and after that data must have been copied up.

Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
---
 tests/overlay/060 |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: xfstests-dev/tests/overlay/060
===================================================================
--- xfstests-dev.orig/tests/overlay/060	2018-08-27 11:21:51.811847671 -0400
+++ xfstests-dev/tests/overlay/060	2019-02-01 11:43:43.354762812 -0500
@@ -170,7 +170,7 @@ test_common()
 
 	# Trigger data copy up and check absence of metacopy xattr.
 	mount_overlay $_lowerdir
-	$XFS_IO_PROG -c "open -a $SCRATCH_MNT/$_target"
+	$XFS_IO_PROG -c "pread 0 1" $SCRATCH_MNT/$_target >> $seqres.full
 	echo "check properties of data copied up file"
 	check_file_size_contents $SCRATCH_MNT/$_target $_size "$_data"
 	umount_overlay
