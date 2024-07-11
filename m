Received: from mail-qv1-f41.google.com (mail-qv1-f41.google.com [209.85.219.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E79C185956
	for <linux-unionfs@vger.kernel.org>; Thu, 11 Jul 2024 23:30:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720740626; cv=none; b=JRWUh/EIq4Ju5kF6tduYRTYKt4aCYCZ0jI85Fa7O1bcOrRQM6QIPs/bMuYqYH3FJ8FfQK0nOnbHA3Gg7/fQBknM7MOFMnfOgUX7Qs7qZ68uOdP0NhDh/vUqV43CtuwgJme3QA68yN52tf8IR2g5gV8xracITdqaHnhR3dV7g4Xc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720740626; c=relaxed/simple;
	bh=X/7U2scGhDei8u1Z20gUgYJ6xZ0qjkFxPu4MvpP+ogY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=LCql3MTudMHTIN56BNOcOs8GL4JOc5Iuc+hrwvky2vZC3eH0DhE8orhtaw8bx44Ak/62b+nF8HLI4CTm275wvQGkQkea57btjtLappdWkZ5bELdyXkj8LNBORWJainChe4DHlxlRHCwVsIuUBlist6b/FUMl7EE+GUWU3h/D7KU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=D69D99eg; arc=none smtp.client-ip=209.85.219.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="D69D99eg"
Received: by mail-qv1-f41.google.com with SMTP id 6a1803df08f44-6b5e0d881a1so19557426d6.1
        for <linux-unionfs@vger.kernel.org>; Thu, 11 Jul 2024 16:30:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1720740624; x=1721345424; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=rIx2S/6PluZdH5LLtd2/41HHAycjU6Wcz+kb5OSErNk=;
        b=D69D99eg8vZWQFxmRa0pEwBQsvrJq1hBkYeaP+id2dsiTLwShuEJi8+pCLCAN+7zM1
         PMgN5YzyQZXw/kSETS8BNQ2g+xXuRV/fIrDd0hiqcaV9xH7RStPq4w1Nv9bXZvpWBRaA
         js3o97mgIZ4I/QCVOf3+pZTrcL1XMPobvvt8KxRPgkrCz/R5QCfrweEJP0I1Xglj+YNS
         glXG4Vhrisr6i4/1cSQ8KvrWtLMBL4BwAsaj2u43DnCYNtCVgEof43aB50ecQhtbCHNq
         5MY8uT2axpNGUqqe1stK81bwt/tvNzyTTLMyEYp5FEQVd8zx94KF7sEe9t814FtMPdVd
         4qww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1720740624; x=1721345424;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=rIx2S/6PluZdH5LLtd2/41HHAycjU6Wcz+kb5OSErNk=;
        b=j0how+FJW7v5Z/PNuo4t+FKQsL9SGhryg234iPVn1OIeUSv5VwrjU79SQsjs4eLIn1
         Pb4rfAr75Sar19WaGbxwPa/JjqGCHtYbB53Hz9+xPMmtEZ2ybjJ6f3T46ZslmH0KtXkC
         1T01HGJLQWFAj706PvHRwzYcLPCdiRWgcHPv9V1gL+LCpYioOyGawkDVmju7IfWe4guX
         /VZLiBaRgAx8sQmwtJUi8Sv0D63EWdmOaTiecndXM4RfaR7wPLvUc1kY8BSetemffrea
         8RFMBReVPrXkUQCyLdj7HJuq6z0zq0VHGk6V/5Ql4IX1zs2e3PygVWVl58JL9CvvbC1d
         DnoQ==
X-Gm-Message-State: AOJu0YwOcirv+X6JzX3MjrQsanVJ5svkhe5WIna7MK7X4VzOIJh5KXJV
	BHhIT5WZTLzmI4P3Bhh6LM5nT711a6ykBIUMRZG7J3FpdrYTMhIsWyZKBi8dK2aQn3Z+HRrkjeX
	fU3PTcDdZoMYOEky9YGlpfrhw3nM=
X-Google-Smtp-Source: AGHT+IGTNBATXozzL21aqwozlJVuEY2mZjkNDR9VZADSgjTbr5DxZg6MFutwENT2fjvEmJNMr9B42intYElxZdsmXvg=
X-Received: by 2002:a05:6214:224e:b0:6b4:f6ed:ab2b with SMTP id
 6a1803df08f44-6b754d40269mr25560816d6.10.1720740623727; Thu, 11 Jul 2024
 16:30:23 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CAPt2mGPUBsiZTWTPWFKY-oLNCNZBY9Vip5DJ7bzvbExtgfZc2g@mail.gmail.com>
In-Reply-To: <CAPt2mGPUBsiZTWTPWFKY-oLNCNZBY9Vip5DJ7bzvbExtgfZc2g@mail.gmail.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Fri, 12 Jul 2024 02:30:12 +0300
Message-ID: <CAOQ4uxggxOinJubYAzFbP2puUN=7FTCSkxPqM=aojwganC_zpA@mail.gmail.com>
Subject: Re: overlayfs: NFS lowerdir changes & opaque negative lookups
To: Daire Byrne <daire@dneg.com>
Cc: linux-unionfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Jul 11, 2024 at 6:59=E2=80=AFPM Daire Byrne <daire@dneg.com> wrote:
>
> Hi,
>
> Apologies for what I assume is another frequent (and long) "changes
> outside of overlayfs" query, but I *think* I have a slightly unique
> use case and so just wanted to ask some experts about the implications
> of the "undefined behaviour" that the documentation (rightly) warns
> against.
>
> Basically I have a read-only NFS filesystem with software releases
> that are versioned such that no files are ever overwritten or changed.
> New uniquely named directory trees and files are added from time to
> time and older ones are cleaned up.
>

Sounds like a common use case that many people are interested in.

> I was toying with the idea of putting a metadata only overlay on top
> of this NFS filesystem (which can change underneath but only with new
> and uniquely named directories and files), and then using a userspace
> metadata copy-up to "localise" directories such that all lookups hit
> the overlay, but file data is still served from the lower NFS server.
> The file data in the upper layer and lower layer never actually
> diverge and so the upper layer is more of a one time permanent
> (metadata) "cache" of the lower NFS layer.
>
> So something like "chown bob -R -h /blah/thing/UIIDA/versionXX/lib" to
> copy-up metadata only. No subsequent changes will ever be made to
> /blah/thing/UIIDA/versionXX/lib on the lower filesystem (other than it
> being deleted). Now, at some point, a new directory
> /blah/thing/UIIDB/versionYY/lib might appear on the lower NFS
> filesystem that has not yet got any upper directory files other than
> perhaps sharing part of the directory path - /blah/thing.
>
> Now this *seems* to work in very basic testing and I have also read
> the previous related discussion and patch here:
>
> https://lore.kernel.org/all/CAOQ4uxiBmFdcueorKV7zwPLCDq4DE+H8x=3D8H1f7+3v=
3zysW9qA@mail.gmail.com
>
> My first question is how bad can the "undefined behaviour" be in this
> kind of setup?

The behavior is "undefined" because nobody tried to define it,
document it and test it.
I don't think it would be that "bad", but it will be unpredictable
and is not very nice for a software product.

One of the current problems is that overlayfs uses readdir cache
the readdir cache is not auto invalidated when lower dir changes
so whether or not new subdirs are observed in overlay depends
on whether the merged overlay directory is kept in cache or not.

> Any files that get copied up to the upper layer are
> guaranteed to never change in the lower NFS filesystem (by it's
> design), but new directories and files that have not yet been copied
> up, can randomly appear over time. Deletions are not so important
> because if it has been deleted in the lower level, then the upper
> level copy failing has similar results (but we should cleanup the
> upper layer too).
>
> If it's possible to get over this first difficult hurdle, then I have
> another extra bit of complexity to throw on top - now manually make an
> entire directory tree (of metdata) that we have recursively copied up
> "opaque" in the upper layer (currently needs to be done outside of
> overlayfs). Over time or dropping of caches, I have found that this
> (seamlessly?) takes effect for new lookups.
>
> I also noticed that in the current implementation, this "opaque"
> transition actual breaks access to the file because the metadata
> copy-up sets "trusted.overlay.metacopy" but does not currently add an
> explicit "trusted.overlay.redirect" to the correspnding lower layer
> file. But if it did (or we do it manually with setfattr), then it is
> possible to have an upper level directory that is opaque, contains
> file metadata only and redirects to the data to the real files on the
> lower NFS filesystem.
>
> Why the hell would you want to do this? Well, for the case where you
> are distributing software to many machines, having it on a shared NFS
> filesystem is convenient and reasonably atomic. But when you have
> sofware with many many PATHs (LD_LIBRARY, PYTHON, etc), you can create
> some pretty impressive negative lookups across all those NFS hosted
> directories that can overhelm a single NFS storage server at scale. By
> "caching" or localising the entire PATH directory metadata locally on
> each host, we can serve those negative lookups from local opaque
> directories without traversing the network.
>
> I think this is a common enough software distribution problem in large
> systems and there are already many different solutions to work around
> it. Most involve localising the software on demand from a central
> repository.
>
> Well, I just wondered if it could ever be done using an overlay in the
> way I describe? But at the moment, it has to deal with a sporaidcally
> changing lower filesystem and a manually hand crafted upper
> filesystem. While I think this might all work fine if the filesystems
> can be mounted and unmounted between software runs, it would be even
> better if it could safely be done "online".

How about this for a workaround:

From your explanations, I understand that you are expecting only specific
directories to grow (e.g.  /blah/thing/ and /blah/thing/UIID*/), while othe=
r
directories are immutable (e.g. /blah/thing/UIIDA/versionXX/) is that corre=
ct?
Can you monitor those directories mtime on NFS using a dedicated service?

If you can then there might be a workable solution to your problems:

- Instead of chown -R to copy up all dirs and metacopy all files
create an identical opaque directory hierarchy and *move* all the
files into the opaque directory hierarchy.
- When the service detects a new subdir on NFS, add the subdir to the
opaque directory hierarchy and *move* the files from the merged subdir
to the opaque subdir of the same name.

The result is that:
- all the directories in the opaque hierarchy are opaque as you wanted
- all the files have metacopy and absolute redirect
- if you take care no to expose the merged hierarchy to users (only to
  the service), then the overlayfs merged hierarchy will not have any
  readdir caches (service only iterates on NFS directly)
- if service only ever accesses the merged hierarchy as the move source
  then there should be no negative lookup caches in the merged hierarchy
- all this happens legitimately while overlayfs is mounted, without
  having to manually tweak trusted.overlay xattrs and drop caches

Assuming that I didn't miss anything and this can work for you,
how can we document it to make the behavior "defined"?

My thinking is:

"Changes to the underlying filesystems while part of a mounted overlay
filesystem are not allowed.  If the underlying filesystem is changed,
the behavior of the overlay is undefined, though it will not result in
a crash or deadlock.

One exception to this rule is changes to underlying filesystem objects
that were not accessed by a overlayfs prior to the change.
In other words, once accessed from a mounted overlay filesystem,
changes to the underlying filesystem objects are not allowed."

But this claim needs to be proved and tested (write tests),
before the documentation defines this behavior.
I am not even sure if the claim is correct.

One more thing that could help said service is if overlayfs
supported a hybrid mode of redirect_dir=3Dfollow,metacopy=3Don,
where redirect is enabled for regular files for metacopy, but NOT
enabled for directories (which was redirect_dir original use case).

This way, the service could run the command line:
$ mv /ovl/blah/thing /ovl/local
then "mv" will get EXDEV for moving directories and will create
opaque directories in their place and it will recursively move all
the files to the opaque directories.

Actually, current code does not even check for redirect_dir=3Don
(i.e. in ovl_can_move()) before setting redirect xattr on regular
metacopy files.

So as far as I can tell, the following UNTESTED patch might
be acceptable, so you can try it out if you like if you think this
will help you implement to suggestions above:

--- a/fs/overlayfs/params.c
+++ b/fs/overlayfs/params.c
@@ -824,15 +824,9 @@ int ovl_fs_params_verify(const struct ovl_fs_context *=
ctx,
                config->metacopy =3D true;
        }

-       /*
-        * This is to make the logic below simpler.  It doesn't make any ot=
her
-        * difference, since redirect_dir=3Don is only used for upper.
-        */
-       if (!config->upperdir && config->redirect_mode =3D=3D OVL_REDIRECT_=
FOLLOW)
-               config->redirect_mode =3D OVL_REDIRECT_ON;
-
        /* Resolve verity -> metacopy -> redirect_dir dependency */
-       if (config->metacopy && config->redirect_mode !=3D OVL_REDIRECT_ON)=
 {
+       if (config->metacopy && config->redirect_mode !=3D OVL_REDIRECT_ON =
&&
+                               config->redirect_mode !=3D OVL_REDIRECT_FOL=
LOW) {
                if (set.metacopy && set.redirect) {
                        pr_err("conflicting options:
metacopy=3Don,redirect_dir=3D%s\n",
                               ovl_redirect_mode(config));
--

Apologies in advance if this idea is flawed.

Thanks,
Amir.
