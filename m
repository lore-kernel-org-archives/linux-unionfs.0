Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2176543BDD4;
	Wed, 22 Jul 2026 15:44:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784735056; cv=none; b=Tw65r7d0GdePULeT5Uw4aeTpaS8kIE5kkjiBFyxFJ75PmVrVC5DcMJSgSKJANXO4z4mkqz1Pk35t8clP9pZaU+wmZnE8802RX0jx1ZLHfVAHLzLbAcGfBjUGqPYIKK1O0UXMaZMQwdD4qTzilgauOktJrXGszauWmwYtq66qyE0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784735056; c=relaxed/simple;
	bh=j+qTEAyCoV00o2kRcC1j4kbG1tTBZxy1Qcm6LbFyZos=;
	h=MIME-Version:Content-Type:Subject:From:To:Cc:In-Reply-To:
	 References:Date:Message-Id; b=JQcn4E1yrG3xMwSQXv8XC1fb67AJGY64KQ8wUxTbtsX4qQtd9bHLjZICiL/PUjkTsOcuxCNy9vcdDXOV83gECmiDZWdO0Yy4oDboJutwCvHZ9WhJda1PoNWg7+WXCOw3ps/W6r7rwHB5bbFBzVAMqMRctUxVa4Ozafzh2r22Z34=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=nWhOfU/M; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="nWhOfU/M"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C58121F00A3A;
	Wed, 22 Jul 2026 15:44:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784735054;
	bh=aIdfFNr/larYFfsrJLug1WIUvAH11kj/nBfq0GHEMDM=;
	h=Subject:From:To:Cc:In-Reply-To:References:Date;
	b=nWhOfU/M9SwLEWbYZtFNK0EAy5+gWvsxVuhLbnlyobS+Y/1gxXgg2vp/wJMwpi+V0
	 5ne6F1aPI63Qplq+QMqJbVsEv2yiKMQx7+nSX8LaZJsQXiq/IVUUDA32xDgJHIDWcE
	 +VGKMp+sXPz0niQ+HCKcBgCvuSNbwrcVEmKFktJckjn9aHrJ8cmJXSPnsjIvmjuC+C
	 XJF+uUOsNxNTtZpEL0+YFdFBaaNRDtE92bsjRMzqGZySV/bkVC4YQndKcPb2ryicRT
	 Ne9qhSkhKur+H/B6OZEEVfiR82fXfeICQG8sojC1K7N2UdTZ2SNZ9IiJB0MdhU5ii/
	 lIjcQE2X2rdAA==
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Subject: Re: [RFC PATCH] fs: allow opening overlayfs/erofs layers through
 O_ALT
From: Christian Brauner <brauner@kernel.org>
To: Miklos Szeredi <mszeredi@redhat.com>
Cc: Giuseppe Scrivano <gscrivan@redhat.com>, linux-fsdevel@vger.kernel.org, 
 linux-unionfs@vger.kernel.org, linux-api@vger.kernel.org, 
 linux-erofs@lists.ozlabs.org, Amir Goldstein <amir73il@gmail.com>, 
 Gao Xiang <hsiangkao@linux.alibaba.com>
In-Reply-To: <20260715101107.973997-1-mszeredi@redhat.com>
References: <20260715101107.973997-1-mszeredi@redhat.com>
Date: Wed, 22 Jul 2026 17:44:08 +0200
Message-Id: <20260722-fundort-zogen-kormoran-09fb867f1b59@brauner>
X-Mailer: b4 0.16-dev-2f6f2
X-Developer-Signature: v=1; a=openpgp-sha256; l=5820; i=brauner@kernel.org;
 h=from:subject:message-id; bh=j+qTEAyCoV00o2kRcC1j4kbG1tTBZxy1Qcm6LbFyZos=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWQlPPURNpbh3u3r+MNt9/vGE3p6dd8q2qtYypnXKfyMz
 lyx4fq6jlIWBjEuBlkxRRaHdpNwueU8FZuNMjVg5rAygQxh4OIUgIk42TMyXDo3q4PzguhyK58i
 k9VXv1hUyx2uWmgvcyD4X5XbtJl71zAydE5jSC7Qixf81HFThUkiujhcm2f3xIffY6zbXolGdfe
 xAgA=
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624

> This is a prototype patch. Needs to be split up!
> 
> 1) O_ALT / OPEN_TREE_ALT
> 
>   These open an alternative namespace rooted at dfd - instead of resolving
>   the path in the real filesystem, it resolves it in a virtual tree that
>   exposes metadata about that file.
> 
>   This is intended to provide an alternative to adding new ioctls:
> 
>    - provides structured namespace
>    - allows accessing data through fs ops
> 
>   Could call this O_META, but O_ALT seems more generic and there could be
>   uses beyond metadata (e.g. seekable, in-place decompression).
> 
>   This has been discussed previously:
>   https://lore.kernel.org/all/CAHk-=wjzLmMRf=QG-n+1HnxWCx4KTQn9+OhVvUSJ=ZCQd6Y1WA@mail.gmail.com/
> 
> 2/a) s_op.get_options(), sb_add_option()
> 
>   .get_options() is a generic version of .show_options().
> 
>   After converting everyting to seq_show_option() the rest is trivial:
> 
>    - change first arg to "struct sb_opt_ctx *ctx"
>    - replace "seq_show_option(m" with "sb_add_option(ctx"
> 
> 2/b) sb_add_option_path()
> 
>   The last arg is "struct path *".  This is for options that designate a
>   path (e.g. stacked fs layers).
> 
>   Will allow opening the path through O_ALT.  Ignored when retrieving the
>   string value of the option.
> 
> 3) MNT_CLONABLE
> 
>   Allow an internal mount to be cloned.  Nsfs and pidfs are already special
>   cased, move these over to this flag.
> 
>   Also allow overlayfs layers to be cloned.
> 
> 4) mnt.mnt_devname -> sb.s_devname
> 
>   This is historical thing, mnt_devname was just copied when cloning the
>   mount, sharing the same value for all mounts belonging to a super block.
> 
> 5) mount options in metafs
> 
>   Support retrieving mount options through O_ALT opens:
> 
>      mount/options/OPT/N: Nth instance of OPT
> 
>   This will be a symlink pointint to the option value. If the option refers
>   to a path (as per 2/b), following the symlink jumps to the given path.
> 
>   At this point only overlayfs and erofs are converted.
> 
> Signed-off-by: Miklos Szeredi <mszeredi@redhat.com>

We've added a primary set of apis to retrieve mount options. I really
dislike the idea of introducing a completely orthogonal layer to do the
same thing (or more) and also make it filesystem based while at it.

The other proposal of moving it into procfs doesn't lower the creepiness
factor. It just paints it a different color. My objection is to the
shape of this not where the entry point lives.

metafs is the same thing in a different color. I really don't see any
way that we would ever merge something like this.

Like, I'm fine having an api where we can use open_tree() to see through
into underlying layers and given the right permission pull a mount out
of it. That seems something we can potentially do.

There's a few issues on top of that. O_ALT is silently ignored unless
you spell the open as openat(dirfd, relative, ...). path_init() only
looks at LOOKUP_ALT in the dirfd branch. open("/abs", O_ALT) and
openat(AT_FDCWD, "rel", O_ALT) fall straight through and open the real
file.

The layer symlinks are an unchecked jump into internal, out-of-namespace
mounts. Following mount/options/upperdir/0 ends in nd_jump_link(). That
doesn't do permission checks and no mnt_ns check.

The overlay upper/lower layers are internal mounts with no mountpoint in
any namespace. So any unprivileged process that can open the overlay
root gets an O_PATH handle to a layer root it has no search-permission
path to and on a mount outside its namespace and can then use it as a
dirfd.

Pulling the mount out is gated by CAP_SYS_ADMIN, but the handle and the
traversal are not. That's exactly Andy's "whose creds" question, it's
inherent to the design, and the procfs variant has it too.

get_options() forks ->show_options() permanently. It's added
alongside the existing method and mnt_show_options() now tries one then
the other.

That leaves the tree split forever or commits us to a flag-day
conversion of everything. The new thig is also heavie and loses the
seq_file overflow-retry. All so the 99% of filesystems that will never
expose a path option can carry a more complicated interface.

mnt_devname to s_devname move is a behavioral change. alloc_super()
records fc->source only on the sb-create path in sget_fc(). Sharing an
existing sb path never updates it. For filesystems that share a
superblock across mounts every mount now reports the first mounter's
source in /proc/self/mountinfo and statmount().

And the smaller details really show how inelegant this model is and why
Al and I have opposed it multiple times before. Scalar options are
modeled as symlinks and non-path options are dangling links whose
readlink still returns the value while for path options readlink returns
the option string but following the link jumps somewhere else entirely.

erofs silently emits a valueless "fsoffset" if the kasprintf fails.
There's no Kconfig at all. metafs is obj-y and kern_mount()ed in every
kernel. I don't want to see this leak into every container going forward
at all with the same hackishness to make it somehow safe in containers.

Like I said before: I'm fine with an API where we can use open_tree() to
see through into underlying layers, and given the right permission pull
a mount out of it. That is a narrow, checkable primitive and it needs
none of this. No new open flag, no second ->show_options, no metafs, no
mnt_devname surgery. That part we can potentially do.

But a generic metadata interface layered on top of yet another magic
filesystem whether it's mounted or hidden behind procfs I feel very
strongly about. I also have great difficulty seeing Al supporting it.

-- 

