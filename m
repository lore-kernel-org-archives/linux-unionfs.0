From: Miklos Szeredi <miklos@szeredi.hu>
Subject: Re: overlayfs /proc paths
Date: Fri, 5 Dec 2014 12:15:20 +0100
Message-ID: <CAJfpegsCXhuFE3qQ3gmampaOGZbPEedwk2SyECfk+KvGXzoD8g@mail.gmail.com>
References: <20141204143901.GB25696@cray.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-qc0-f172.google.com ([209.85.216.172]:61548 "EHLO
	mail-qc0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751858AbaLELPV (ORCPT
	<rfc822;linux-unionfs@vger.kernel.org>);
	Fri, 5 Dec 2014 06:15:21 -0500
Received: by mail-qc0-f172.google.com with SMTP id m20so260518qcx.31
        for <linux-unionfs@vger.kernel.org>; Fri, 05 Dec 2014 03:15:21 -0800 (PST)
In-Reply-To: <20141204143901.GB25696@cray.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Dean Roe <roe@cray.com>
Cc: linux-unionfs@vger.kernel.org

[Cc linux-unionfs]

On Thu, Dec 4, 2014 at 3:39 PM, Dean Roe <roe@cray.com> wrote:
> Miklos,
>
> We have started using overlayfs on our systems, and have found that
> a known shortcoming is causing us grief.  From the Documentation file:
>
>   Symlinks in /proc/PID/ and /proc/PID/fd which point to a non-directory
>   object in overlayfs will not contain valid absolute paths, only
>   relative paths leading up to the filesystem's root.  This will be
>   fixed in the future.

[...]

> I was wondering if you had thoughts on how to address this issue, and whether
> it was near the top of your list?  Not knowing enough about overlayfs to do a
> re-design of its use of private clone mounts, I hacked something together to
> see what it would take to traverse the paths with the infrastructure in place
> today.  If you are curious, you can look at the attached patch, but the result
> is a hack that is certainly not acceptable.  Any thoughts on what the right
> path forward should be?

Some hints from dhowells and Al follow, not sure if any work on this
has started or not.

On Mon, Oct 20, 2014 at 5:47 PM, Al Viro <viro@zeniv.linux.org.uk> wrote:
> On Sun, Oct 19, 2014 at 10:31:52AM +0100, David Howells wrote:
>
>>      For overlayfs, the way this probably should be done is file->f_path should
>>      be set to point to the overlay dentry (thus getting /proc right) and
>>      file->f_inode to the lower file and make use of d_fallthru in the overlay
>>      dentry in common with unionmount.
>
> To elaborate a bit: a _lot_ of places in filesystems that used to use
> ->f_path.dentry->d_inode had been eliminated in favour of file_inode(...)
> and all the remaining ones ought to follow.  With that done (I was actually
> planning to do whack-a-mole session on those guys after most of this cycle
> merges would be done - Linus, would you accept that in -rc2?) we get
> surprisingly few places that even look at ->f_path.dentry.
>
> Some of those are refering to ->d_name; we need to review those for other
> reasons (potential rename() races), but for unionmount/overlayfs purposes
> we couldn't care less which of dentries is used - both overlayfs and
> underlying fs dentry have the same name.  FWIW, a bunch of uses are in
> printks, and those should become %pD...
>
> A bunch of places uses ->f_path.dentry->d_sb to get the superblock by
> file; file_inode()->i_sb would do just fine in filesystems.  And places
> like that *outside* of filesystems need a bit of review - the question is
> which superblock do we want?  That of overlayfs or that of the layer?
> The latter would be file_inode()->i_sb, again.  The former would be a problem
> with overlayfs in its current form; with leaving f_path to point to overlayfs
> it would work fine.
>
> dir_emit_dot() and dir_emit_dotdot() use ->f_path.dentry, but those are not
> problem - overlayfs explicitly opens directory in a layer.
>
> AFAICS, nothing of what remains is on paths hot enough to really care about
> an extra dereference.  So I think that after the dust from cleanups settles,
> we'll be able to add an inlined helper usable for accesses to file's dentries,
> and ban open-coded ->f_path.dentry in filesystems.

Thanks,
Miklos
