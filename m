Received: from mail-ej1-f53.google.com (mail-ej1-f53.google.com [209.85.218.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38FA429B79B
	for <linux-unionfs@vger.kernel.org>; Sun, 29 Mar 2026 09:31:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.218.53
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774776670; cv=pass; b=FldmU3n3E3s/ItREFMZezdSuXvMIpPMCf8bTJDsUaS0xSxd5ZE5Er4w1dX4r25zUEQWqgehxSJq0VeHuZ3oYv8Cws5XF2dYhbNQljwefj/QNr0UpLVSWIT4/AXFZIRXsbyl2di8nF9h70Jl93eGGCzeJ3nTd5sJnG0tkFb9XdkM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774776670; c=relaxed/simple;
	bh=TNBMBfGJlNaiFl/rXCAibtVADrbjoAOSzphuoXQu4BQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=QfAxnD9uJftVMoojC8kluroDlXWb99fYIw5VorUwUvwFcxCFeWBOKcJMjyYizSqf9mEm1ZBqusgqmJHYxOD9/cO1tXeOo7bLUuFKQT+Yz7EgYKoW6cBMdn2PTfAEXF/4Gg99Vfm0XRStH3Wq8zBDtDfjtMjHUu5heUZ7zdXDuYk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Gkaxpgo9; arc=pass smtp.client-ip=209.85.218.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Gkaxpgo9"
Received: by mail-ej1-f53.google.com with SMTP id a640c23a62f3a-b97c44417ffso353132666b.2
        for <linux-unionfs@vger.kernel.org>; Sun, 29 Mar 2026 02:31:06 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1774776665; cv=none;
        d=google.com; s=arc-20240605;
        b=e9C9T2Z0Hn2uMjjQ5j/J48jSs76teh1dZnV5luAU1yByvmFU4nZo2h1SwmotzIJ/8M
         4VEEbqdPl+uCjM1bMWEzoNGbDzpu3U6zl5tXX1N1uBSZ9HXZqCPOCsFA4XYQuqFtBRCI
         8Ih1OIVeCoYyViOdGaU03z+nG7266TTW2jcz1K3kX8DQGADdM8hP2NQ+64c5vAVSEHq8
         rU6eB2MaNJ9p/6tDTC8WqyCVcr1zEHVzs5ERgTIVWVLQngAw5zTcfKx7/XRPeunIxmlI
         wdVdBcaAUarr18rBxgXGpL0Q7zurBQMP09JjTyfy4Y1NYWRhBBVTOzncvree6KG+JVYD
         N6ww==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=eVUmKWILiSQiKsihXpJwE523TTZkCBN7KtwbYpicI5M=;
        fh=f2JEp+Fi7gQ+T3KDANaHOz1C0Q/WhgUhsDsc0OFbhjw=;
        b=F9zEgq9Axocg0l72+LY34N6n0HW5MyeZvNSMvI3bnfbnCslTQ/ayaoKuBl0eTW3MRT
         SHrJPQtEAtPaFKWjL520Lkr60Kn+QomODz0ZhI1RCQ3YyRnaZvIapxX7cqDIYqewzSzY
         TRynKEyuROhhQ0qdZFxMI3qYstpT3av+PwtW4XMGicz19g8rS7OlY6rJoO4a6HzQTkdL
         plFBh+G+CLiXD+cDBDP+gsmKJ0TGZ4KaLGlXUvaynyKxxEUCXIvtQa5VcaOrQvFzrVri
         keECtmtrmpmmOfVkMv5Jdhf22ZRXvJRm/tD9Y5zODkQ+xKmscipXxffqiA2uwxSzbe9F
         L9zw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1774776665; x=1775381465; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=eVUmKWILiSQiKsihXpJwE523TTZkCBN7KtwbYpicI5M=;
        b=Gkaxpgo9ehCPURtHlRoeIWcC8f1gcybLnj1NOfnZpE2btnil1MXyDg7d910RQUk8H3
         meRfHewXjgICd2prWsgGS13zYc7npwUlUwJWriw9kfkjFNtUwR55g4EryQERFUEQQ3tB
         aW4QYep/BWlo0oaID2Z+XcwIXRbOKg4QNvivgGIoeAw63Nja5LDbbplbuqlun82A3Mdo
         SA2OBp2WDZqvN7vMWKwixLdM5Dhjy7qkvRw6FhK/7SkgzhHY1Slm+i15/pXDShWJCwIl
         R8m2Y0VZzosJTNZ0Tj3A67VhY2we2xBe88225poBnmYOqQYIkpAswttCzNK6YRJUqv+j
         V1Xw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774776665; x=1775381465;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=eVUmKWILiSQiKsihXpJwE523TTZkCBN7KtwbYpicI5M=;
        b=q65fYSM/PmRvHGoA7TtAA/I2kkLDGnv5PkmtI76pFO+3xg75rGO0v42GEIjem7NazV
         y5c8iQOH++hOZTU1/XLw6xomEEikCx0KDIdzvzWe4TzYZ/QTSURQ+T1588GlHddGKV51
         4KY/2CmsXGm+gcyMuqa+6npwZDNhCZ/IjZAyHrdCChBUssIzWNS3PoTwK8GXAOZKv7AX
         maIG4UekVnXNcvHUC45l6NFlG+JtjXezSR0PjZbRE84tn7CNNyDlt/1W4CSUMq5u+JPc
         v7q42Y7p1Tw17jdT6sy+316mVHx369YP7//cnuWhVsO/AwQOnjW00h3Ej04coNxDGEKK
         2JtA==
X-Forwarded-Encrypted: i=1; AJvYcCXe/NV6ttnRgArBaZKd+Z4g/UrqY83eZ6EfJvZ3vReAkFAAh/Aw7KzRGTGJcChBtDzt7dukziK+5Dd7esZS@vger.kernel.org
X-Gm-Message-State: AOJu0YyxeID4nhBqg570ovlYXUFYr4XBO8NuZT2jEfsZUxK76jKB8i4J
	o3DXq85szBEh8+PjYv4tluZjHPeWnxsC4AwvZSJjoibfhIwdTuko9/XtmWKBiAMlVrA5YUTBZ/2
	sfKGJc9NObcKnsN9m1GvdKQ6x7PThDw4=
X-Gm-Gg: ATEYQzyVGNzsqogrGlTPuCg5kj/rgIusubhJExdu+guDp3FWJ7LgrCin13/y8/d78YD
	k0LVLhMQBCcN6VUeaDj3o7lUwkjXi3L4MQP1YUXRY/5O2sZQFr8SGj7npUdDlKIKdA0ruyPeq+W
	8jDmrUBbrwO9UFBr3zAoheQgaKlPSphbZ5+sWXzHdUM25oCwQYnFofcBg57AMAJHK6NnGz0XDFq
	YAS2CeZRV27LRdd1XeW4EXvXoGEVdDa2LgFhh2Ep33sCOBxuDE8yA4T8xUPbojxdfvKkxrcKFRh
	PRlnAGGxBETmZfMYKLY8giQso//Jg5lB0NyMCytr9w==
X-Received: by 2002:a17:907:7b06:b0:b98:443:6f33 with SMTP id
 a640c23a62f3a-b9b509a1d23mr515627466b.51.1774776665317; Sun, 29 Mar 2026
 02:31:05 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260329092658.90712-1-amir73il@gmail.com>
In-Reply-To: <20260329092658.90712-1-amir73il@gmail.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Sun, 29 Mar 2026 11:30:54 +0200
X-Gm-Features: AQROBzC6OyJ4EpzvT3lMx9bk3nAPfyuKbn4lCBt69uK2moonOou_6g1OlzHplvY
Message-ID: <CAOQ4uxjjt1idAf9t+QSSGrtfo_TGF6qFD1-FY1JSaN7DzbtOWw@mail.gmail.com>
Subject: Re: [GIT PULL] overlayfs fixes for 7.0-rc6
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Miklos Szeredi <miklos@szeredi.hu>, Christian Brauner <brauner@kernel.org>, 
	Chenglong Tang <chenglongtang@google.com>, linux-kernel@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, linux-unionfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sun, Mar 29, 2026 at 11:26=E2=80=AFAM Amir Goldstein <amir73il@gmail.com=
> wrote:
>
> Hi Linus,
>
> Please pull overlayfs fixes for 7.0-rc6 to fix two regressions
> from v6.7 (minor impact) and from v6.12 (major performance impact).
>
> This branch has been sitting in linux-next for a couple of day and
> it has gone through the usual overlayfs test routines.
>
> The branch merges cleanly with master branch of the moment.
>
> Thanks,
> Amir.
>
> ----------------------------------------------------------------
> The following changes since commit f338e77383789c0cae23ca3d48adcc5e9e137e=
3c:
>
>   Linux 7.0-rc4 (2026-03-15 13:52:05 -0700)
>
> are available in the Git repository at:
>
>   git://git.kernel.org/pub/scm/linux/kernel/git/overlayfs/vfs.git ovl-fix=
es-7.0-rc6
>
> for you to fetch changes up to 1f6ee9be92f8df85a8c9a5a78c20fd39c0c21a95:
>
>   ovl: make fsync after metadata copy-up opt-in mount option (2026-03-27 =
12:48:10 +0100)
>
> ----------------------------------------------------------------
> overlayfs fixes for 7.0-rc6:
>
> - Fix regression in 'xino' feature detection.
>   I clumsily introduced this regression myself when working on another
>   subsystem (fsnotify).  Both the regression and the fix have almost
>   no visible impact on users except for some kmsg prints.
>
> - Fix to performance regression in v6.12.
>   This regression was reported by Google GOC developers.

Oops typo (should be Google COS)
You may want to fix this in your merge commit.

>   It is not uncommon these days for the year-old mature LTS to
>   get adopted by distros and get exposed to many new workloads.
>   We made a sub-smart move of making a behavior change in v6.12
>   which could impact performance, without making it opt-in.
>   Fixing this mistake retroactively, to be picked by LTS.
>
> ----------------------------------------------------------------
> Amir Goldstein (1):
>       ovl: fix wrong detection of 32bit inode numbers
>
> Fei Lv (1):
>       ovl: make fsync after metadata copy-up opt-in mount option
>
>  Documentation/filesystems/overlayfs.rst | 50 +++++++++++++++++++++++++++=
++++++
>  fs/overlayfs/copy_up.c                  |  6 ++--
>  fs/overlayfs/overlayfs.h                | 21 ++++++++++++++
>  fs/overlayfs/ovl_entry.h                |  7 +----
>  fs/overlayfs/params.c                   | 33 ++++++++++++++++++----
>  fs/overlayfs/super.c                    |  2 +-
>  fs/overlayfs/util.c                     |  5 +++-
>  7 files changed, 108 insertions(+), 16 deletions(-)
