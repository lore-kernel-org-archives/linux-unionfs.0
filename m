Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E44C13633F
	for <linux-unionfs@vger.kernel.org>; Wed, 28 May 2025 08:47:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748422072; cv=none; b=Yzc3LuncLr5NpxnhVukFYmI5P5Nwue8pdI/eCa/Rxs6r2kSvms7cHGdamUVDYUBakSuHQFqsRwRYsiM+Tmw4KBtSOdrlptx/Y0RaPwZqkNJNN3bDMzhMwglly3eZNGh0QU0TCr2mUOFSPGW0s33FiFXcXXaH0aQEtxMGFjcx0qU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748422072; c=relaxed/simple;
	bh=zCqV1rTgrW4eHVIuYE2IUuphjW6ivnFlzBmXNA+cKLQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Mo+k29Kr/ekjfX8D9fIqRz8R5QWpjzaS9tiBv98prRHxPInSicnXZhHIWZeYPLcxf8eNIn2eZ+nEWIqPx/9/hppjkkGAnJmoWDaUGwxWhfAcqtoTK8PgmnewtjP+wqwsQci26Gs06f2RkZV/QNH+6eYeAfXx1cnpUVDAjk9Jcz4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=IIkoCs71; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="IIkoCs71"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1748422069;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=o50dZP3QkVHpB3LosN+EWXcCuA0vClemDgJtmBkO/4E=;
	b=IIkoCs71SGLQZI0XdfXHe8m5LgWKGjgFw2V3RVRY5+DqHxmbwYASD/rIp+z6Tb/ps7ipnh
	sS3pPqKHXMiut+v0vUIgt1DJSnQ5a+QHkvmbMMqUq/pm2zvIe4NJi8HbsFr9vO5r9wJS0i
	/2nDWvlyZ2LzEayjW6MKP/dvtknKQRI=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-128-0WJI_lC_OgG93iS5D0Pimg-1; Wed,
 28 May 2025 04:47:46 -0400
X-MC-Unique: 0WJI_lC_OgG93iS5D0Pimg-1
X-Mimecast-MFC-AGG-ID: 0WJI_lC_OgG93iS5D0Pimg_1748422065
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id AD7C81800368;
	Wed, 28 May 2025 08:47:43 +0000 (UTC)
Received: from ws.net.home (unknown [10.45.225.54])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 3094918004A7;
	Wed, 28 May 2025 08:47:40 +0000 (UTC)
Date: Wed, 28 May 2025 10:47:37 +0200
From: Karel Zak <kzak@redhat.com>
To: Amir Goldstein <amir73il@gmail.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, Zorro Lang <zlang@redhat.com>, 
	linux-unionfs@vger.kernel.org, fstests@vger.kernel.org, 
	=?utf-8?B?QW5kcsOp?= Almeida <andrealmeid@igalia.com>
Subject: Re: [PATCH 1/4] overlay: workaround libmount failure to remount,ro
Message-ID: <rjqagpvze4mwnil6tck6jnyqfbcgqszy5bjgu4fqzdtq7e3idq@uizmifogsqyf>
References: <20250526143500.1520660-1-amir73il@gmail.com>
 <20250526143500.1520660-2-amir73il@gmail.com>
 <CAJfpegtYTpJXYOiyckcfQA=YTVXcLQZRGV4=sjueLenJpTp7Lw@mail.gmail.com>
 <CAOQ4uxjh9u3DE_HKExa=kK08efzDsxVuCVuA0tUMjwSeLX=jnQ@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAOQ4uxjh9u3DE_HKExa=kK08efzDsxVuCVuA0tUMjwSeLX=jnQ@mail.gmail.com>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93

On Wed, May 28, 2025 at 08:54:51AM +0200, Amir Goldstein wrote:
> On Tue, May 27, 2025 at 4:49 PM Miklos Szeredi <miklos@szeredi.hu> wrote:
> >
> > On Mon, 26 May 2025 at 16:35, Amir Goldstein <amir73il@gmail.com> wrote:
> > >
> > > libmount v1.41 calls several unneeded fsconfig() calls to reconfigure
> > > lowerdir/upperdir when user requests only -o remount,ro.
> >
> > Isn't this a libmount bug then?

It's not just "only -o remount,ro"; the mount manual is quite explicit about it:

   The remount functionality follows the standard way the mount command works with
   options from fstab. This means that mount does not read fstab (or mtab) only when
   both device and dir are specified.

        mount -o remount,rw /dev/foo /dir

   After this call all old mount options are replaced and arbitrary stuff from fstab
   (or mtab) is ignored, except the loop= option which is internally generated and
   maintained by the mount command.

        mount -o remount,rw /dir

   After this call, mount reads fstab and merges these options with the options from
   the command line (-o). If no mountpoint is found in fstab, then it defaults to
   mount options from /proc/self/mountinfo.

   ...

   --options-mode mode
           Controls how to combine options from fstab/mtab with options from the command line.
           mode can be one of ignore, append, prepend or replace. For example, append means
           that options from fstab are appended to options from the command line. The default
           value is prepend — it means command line options are evaluated after fstab options.
           Note that the last option wins if there are conflicting ones.


Anyway, I agree that this semantics sucks, and from my point of view,
the best approach would be to introduce a new mount(8) command line
semantics to reflect the new kernel API, something like:

   mount modify [--clear noexec] [--set nodev,ro] [--make-private] [--recursive] /mnt
   mount reconfigure data=journal,errors=continue,foo,bar /mnt

and do not include options from fstab in this by default.

> > Working around it in xfstests just hides this, which seems counter productive.
> >
> 
> Yes, to some extent, however, IMO the purpose of fstests is to test the
> filesystem and the vfs and for very fs-specific tests it also tests the
> *progs utils.
> 
> I do not think we can afford fstest being a test for libc+libmount and the
> entire ecosystem. That's part of the reason that fstest implements
> some of its own utilities to exercise syscalls.
> 
> If we leave the tests failing, we will loose test coverage from all
> the people that are running with not-cutting-edge distro.
> I don't think this is a desired outcome for us.
> Test coverage for remount,ro is pretty important IMO.
> 
> FWIW, we already used LIBMOUNT_FORCE_MOUNT2 to workaround
> another libmount bug I believe you were in the loop when we did that
> (see blow).
> 
> Any other idea how to address those libmount bugs in the test suite
> other than keeping the tests failing or not running for libmount >= v1.39?

Why do you think it's a libmount bug? Do we really expect that
userspace will parse filesystem-specific mount options and "if
(overlayfs)" then it will exclude some options from fsconfig()?

# LIBMOUNT_FORCE_MOUNT2=always strace -e mount mount -o remount,ro /mnt/merged
mount("overlay", "/mnt/merged", 0x561d36355030, MS_RDONLY|MS_REMOUNT, "lowerdir=/mnt/low,upperdir=/mnt/"... ) = 0

# strace -e fsconfig mount -o remount,ro /mnt/merged
fsconfig(4, FSCONFIG_SET_STRING, "lowerdir", "/mnt/low", 0) = -1 EINVAL (Invalid argument)

As you can see, mount(2) is absolutely fine with lowerdir=. Why not fsconfig()?

I think the way libmount uses fsconfig() is exactly the same as how it
uses the classic mount(2), just sending the mount options to the
kernel. The difference is only that for the new mount kernel API, we
differentiate between filesystem options (fsconfig()) and VFS
attributes (mount_setattr()).

Would it be better to ignore attempts to reconfigure the
lowerdir/upperdir in the kernel?


And example if you suppress fstab/mountinfo:

# strace -e fsconfig mount --options-mode ignore -o remount,ro /mnt/merged
fsconfig(4, FSCONFIG_SET_FLAG, "ro", NULL, 0) = 0
fsconfig(4, FSCONFIG_CMD_RECONFIGURE, NULL, NULL, 0) = 0

or if you specify both, source and target:

# strace -e fsconfig mount  -o remount,ro overlay /mnt/merged
fsconfig(4, FSCONFIG_SET_FLAG, "ro", NULL, 0) = 0
fsconfig(4, FSCONFIG_CMD_RECONFIGURE, NULL, NULL, 0) = 0


So, you do not need LIBMOUNT_FORCE_MOUNT2= workaround, use
"--options-mode ignore" or source and target ;-)

    Karel


-- 
 Karel Zak  <kzak@redhat.com>
 http://karelzak.blogspot.com

