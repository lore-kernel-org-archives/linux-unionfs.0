Received: from mail-ed1-f54.google.com (mail-ed1-f54.google.com [209.85.208.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5FA0B43F8DB
	for <linux-unionfs@vger.kernel.org>; Thu,  3 Sep 2026 08:34:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.208.54
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788424480; cv=pass; b=WiTXzCpyzb9BV2RfxvdY6G+Nepov8PJpyRMeSQxGXJyYbaYT4eBHWvmUe4V28Hl4D3gFO9FN8k6OYuNpyG+spuLi4QjXeDgTEmABF0fvgq5/oLrlNs0BmmESLMyL9rIpaY9nbn3MY6SyAAAQ0VkaYsDiTgRrwzRfWeItd+azxLs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788424480; c=relaxed/simple;
	bh=etd187TpI0PP1zkb6tbrAxzEXe26dhX7HU1+umSCHVk=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=g6DfwgkhAa+4M1sM4/BB1QEY3yKLddABXUYyQX4ht+MUQYztDY5CpmEgVzYCrVh7oNvouiOnTY2vx0wD2vWWYlFvkQmOhlkbAQeU23UJvP59bO9JkRT4a2aivoQTTwZfGiFrp4Llkt7VZxO+n/3Xk7Cqq079JeDlPNe+Aekx1+s=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=S2ijmpn6; arc=pass smtp.client-ip=209.85.208.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="S2ijmpn6"
Received: by mail-ed1-f54.google.com with SMTP id 4fb4d7f45d1cf-6a60f0dbeccso2874398a12.0
        for <linux-unionfs@vger.kernel.org>; Thu, 03 Sep 2026 01:34:38 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1788424476; cv=none;
        d=google.com; s=arc-20260327;
        b=AxP7pBG1VfD66JcWvaw9Kiad/rmZrsfOyOQDcfskAhSj6YIK3l7dK30/3b4beEMHS5
         WugBvfyi7qD7p5YeTmAWEOLIi0pKiZyybJ0bIgZFn46hBYy0T3swldysJdCv5QxSC3B3
         J1JV9755GHZH4s9R0OWpaLVV7XtJEVPC7M+pPkUnKKDhitHiNoZPVcbFlPabM1Ji9pJG
         6r8jUm2jaiYEX6gwSh3jUkmGZskMAdmTEP3y5TUTy6cbvn+d4Z59XeDabmD1vwH9kWVR
         I9HfbzRtBInrD8wZeZetzzGJFufwMi7exktKmBhd97KaJ8iKcYEsTS/Zp3jDG+KOUYzQ
         ECcw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=Dolvj6C6tALOBaQBqhpP7VTgcMtPNpSrLqCXlLOQM/k=;
        fh=A7bRK1c4tUQJPuzhceM3ylSrtRtNTEguxo6/psUFkHY=;
        b=V1rKcsXzf2tO34zfzx5PRttx9Ccc13ZsffkudKy3oh1b95dV3nS8g6mAgylqMRSQSl
         37c4+zUoL7POszxd/mCzEQ7d3j41FKrdgEzQWctyvX4IIKsj3Pn9qjvTQ0Smw2WmGDb/
         dCdyt/50/zfrOsD41pWkAEakA80Kk8k7naRjb+3UHZlB9oDmk5Y5+hXUtSW5q79IcbqV
         txK/Hu1XToTfvEFtKpKyS6618fsGBmxuRuswTGon5ddZo06Ry5MKmA8J0xsKUDT4Y4b0
         8ZnNnny14UwIDjLR6N3QjZUcZnJB7RP5huFzEW5IVMBU9wpCEn0hvoccdYTrd8hmfXnx
         P3Xg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788424476; x=1789029276; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=Dolvj6C6tALOBaQBqhpP7VTgcMtPNpSrLqCXlLOQM/k=;
        b=S2ijmpn6XQlC1B61kQMoEx+4+WWnDwtAbnhEpJkai1nvl8VGvjaoTkJonykVgDVuNI
         ec0ufjDQNuaycu20mqKmutMsJUmf9h60aE8Y/rLirnaRVQoDCaG1Nzkyp+J2Ay7qUJQz
         QZFzHGGqTqTrG/8Xx/ElHMp4EUNOE2Rfmx7sImA8ET6GgRD1P6zJ73iogLBd4JnOUHvO
         pNNXuJ0RwC0NOX0wW8ZUXfWWCCLfYlS6Gpnp+fyH4Irn0vgv1FHolPBjrtEr7dhmskJx
         Eec1M0QcXO24OpjU62X0vFd0wj0OcDK0nZSWQ1VQuhztnLxEeh/Rcaind98VDX7xxwvh
         QEZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788424476; x=1789029276;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Dolvj6C6tALOBaQBqhpP7VTgcMtPNpSrLqCXlLOQM/k=;
        b=phey7nZvx/H3D1mdgojQPmLb2VfzXYrOdTjKmL3Dvj8X0pWmQ2wNmVF/nYd9J6WtR1
         f8X32LfZBcJnB3Ey5Q0cKvv6U7YCsxNXxYyvwl8Hh98IQjOTKt47bqHd0og8Qm2pDi8C
         CnCTS9BAwmCT5XnEpN6bkR70LG451qLuGd9elPhR5NDZf+QiDJyidIeXNKHqny66laBs
         spJdNus8vLhfOvIl/0sJccJhUPpMmEIdQfritOim9brsm2YTzE16CbcFrYDvR8wanjFl
         AYXc69N5tfm+HdLxikF0vNH+EXEMAF0AidlVLhMGJBUShRDo7G+sn8FdsTuqwYNc0FUF
         FshA==
X-Gm-Message-State: AFuF++mlMXNBpjx+Ik12kC4oqyvkmbAzSapli3U3tJ3V8Su/b2VSDpkw
	gg/GXV+LTeC8lHlor64RL9ZQhOZbFtMalHaldV7G7QRYnWhEO2AeN0LZI9eimev3xzBGuXWFCSE
	ls1+erOwnNEcxGKFBwEGVZSheWNBs2Cg=
X-Gm-Gg: AYBFou2J5xG16SqKfr3q5j3pSbnbEFsq0agNPqx9YTJ9NtRg8VBvJt5X5YvLHtx75fi
	Btu24NZzc1gGH8ANukBt3mk1m5i87b2psMBNlSVjxfjPyLnTmGanexS/qp5W9N/4K7ZaAmQOHfx
	IVWkpVozZSgbmnVcthPtgmu9rc6M5RoSZ5Dg9FcgAMISbmfdLEEpXY/kCEf1d4LWPRkoOGToG/I
	wxbb3J9D7idkY+UpLIT9rloNxUZzCrtld4t7NoZOvzHaiCpfCSulUMO+Y2k5718ecFFf9KxV/ry
	jhFhhWcQwJhnUH93s8HqIf3JcKES3wA0qhKVCUKgwOaTLw==
X-Received: by 2002:a05:6402:218a:b0:6a5:f912:b092 with SMTP id
 4fb4d7f45d1cf-6a68257bd75mr7434639a12.6.1788424475997; Thu, 03 Sep 2026
 01:34:35 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260903033359.1042529-1-cui.tao@linux.dev>
In-Reply-To: <20260903033359.1042529-1-cui.tao@linux.dev>
From: Amir Goldstein <amir73il@gmail.com>
Date: Thu, 3 Sep 2026 10:34:24 +0200
X-Gm-Features: AcwNN1XgB3axVosVAZNnl8gVMfhfG0JIK2RYjsYKflkRqfw1XG5URS6oXQXwP0Y
Message-ID: <CAOQ4uxgyPhJQueqUJuwS8=4wGxTAC1Nhy+gfFxrEfaL5A5-EOw@mail.gmail.com>
Subject: Re: [PATCH] overlayfs.rst: document cross-layer file lock and lease semantics
To: Tao Cui <cui.tao@linux.dev>
Cc: linux-unionfs@vger.kernel.org, miklos@szeredi.hu, 
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, 
	brauner@kernel.org, jlayton@kernel.org, Tao Cui <cuitao@kylinos.cn>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Sep 3, 2026 at 5:34=E2=80=AFAM Tao Cui <cui.tao@linux.dev> wrote:
>
> From: Tao Cui <cuitao@kylinos.cn>
>
> Locks and leases taken through an overlay attach to the overlay inode,
> while opens of the same on-disk file through its real upper/lower path
> operate on the underlying inode.  The two do not conflict, so an
> "exclusive" flock/POSIX/OFD lock or a write lease held via the overlay
> is silently bypassed by anyone reaching the file through the layers
> directly, e.g. backup tools walking a container's upperdir or another
> overlay mount over the same layers.
>
> Locking through the overlay succeeds and appears to work, so the lack
> of mutual exclusion only shows up as data corruption when the two
> sides write concurrently.  Document the semantics, the affected
> scenarios and the recommended practice.
>
> Signed-off-by: Tao Cui <cuitao@kylinos.cn>
> ---
>  Documentation/filesystems/overlayfs.rst | 27 +++++++++++++++++++++++++
>  1 file changed, 27 insertions(+)
>
> diff --git a/Documentation/filesystems/overlayfs.rst b/Documentation/file=
systems/overlayfs.rst
> index 16c35b491dad..546b77e66016 100644
> --- a/Documentation/filesystems/overlayfs.rst
> +++ b/Documentation/filesystems/overlayfs.rst
> @@ -884,6 +884,33 @@ The "-o userxattr" mount option forces overlayfs to =
use the
>  useful for unprivileged mounting of overlayfs.
>
>
> +File locks and leases
> +---------------------
> +
> +File locks (flock, POSIX record locks and OFD locks) and file leases
> +taken on a file through the overlay attach to the overlay inode.  The
> +same on-disk file opened through its real upper or lower path is a
> +different inode object, so locks and leases acquired through one path
> +do not conflict with locks and leases acquired through the other.
> +

Hi Tao,

Thanks for your contribution, but it is not acceptable as it is.

Everything written above may be true, but a document needs to be coherent
and this text was written without regard to the context of the document.

The most relevant context is:

  Changes to underlying filesystems
  ---------------------------------

  Changes to the underlying filesystems while part of a mounted overlay
  filesystem are not allowed.  If the underlying filesystem is changed,
  the behavior of the overlay is undefined, though it will not result in
  a crash or deadlock.

TBH I am not enthusiastic about documenting what may happen
on changes of the underlying layer beyond this statement.

I am fine with clarifying a bit about the lock scope, but not as much
as you did -
keep it to bare minimum which is useful.

Also when writing text in this document you need to use terminology of
the document, for example, "same on-disk file" is incoherent with how
this document refers to underlying layers.

> +An "exclusive" lock or a write lease held by a task that opened the
> +file through the overlay does not prevent another task from acquiring
> +the same lock or opening the file if the latter reaches the file
> +through the underlying layer directly, e.g.:
> +
> +- a tool running outside the container accesses the container's
> +  upperdir/workdir or the image layers below it directly,
> +- a second overlay mount is stacked over the same upperdir,

This is really a disaster setup. I won't even discuss what could go
wrong with sharing an uperdir

> +- the same layers are shared between different overlay mounts.

This is obviously normal so not sure why it is relevant

> +
> +Locks and leases do provide mutual exclusion between tasks that all
> +reach the file through the same overlay mount, and a lease taken
> +through the overlay is broken by opens through that overlay.
> +
> +Do not rely on file locking for mutual exclusion between overlay
> +users and anything that may touch the underlying layers directly.
> +
> +

These two statements are the only ones that seem relevant to me
and I would add them in the context of
"Changes to underlying filesystems" not as a separate section.

Thanks,
Amir.
