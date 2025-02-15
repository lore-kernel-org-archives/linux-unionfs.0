Received: from mail-ej1-f46.google.com (mail-ej1-f46.google.com [209.85.218.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4EAC1373;
	Sat, 15 Feb 2025 09:31:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739611870; cv=none; b=huv23VZFy2A/FXDhEpId9dGxYYJR5cFqKtIGV/eDnkaC+cg3WhsyEXSF/BThUOZdqZVC1XfHbLDPKL/sFU8CzMIAHpqGHCDAz9/NUHbFuJ7VgnU90dX2GW0REoiRwJ7beJ532fJ4dVHAsB7ZlQh8rcuPI0szEi1BLf9KvTnpKU0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739611870; c=relaxed/simple;
	bh=ZPGjz6ysPZyVFaQS+K6G06ByTeln3nJSJu9h0gBrKww=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=o5DZjhlUdezMhTceUuieS/+YVORqGdRYOn/DMw4wls6ixW16opj//1MQPvX1JIO4uwwq0PX2LQdzLsisqLoM4Ul/Xom4Bq1RwuTPSls7qH9QuPo//5hBGplk0wJ+vwEa8JplJ5MnnD9N22Ievo597n7Y54Z2xKmvsMxFb88V5XE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Oto2mtUL; arc=none smtp.client-ip=209.85.218.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Oto2mtUL"
Received: by mail-ej1-f46.google.com with SMTP id a640c23a62f3a-ab2b29dfc65so412060766b.1;
        Sat, 15 Feb 2025 01:31:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1739611867; x=1740216667; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=A68stfW/y4+te0SMbEKg7jzS2TB8Xg5jlmvb5fcRKaw=;
        b=Oto2mtULWoX7cPQld2d4kHDooEp5yXGgu5TG1bvUr6cUOHPJsXI4P0fyQMQJeH1j1X
         PnyKeemO2AECe9t/Q1SmZAejFy/WaYk264nYPEdzT5JLZrlXcGJtVWhC1iGabQTMViRY
         HHepkEoIbMNIoM0FsDAJFDo2jZYtuaSvbFKw/7eQWno4Du5+/XyTuV5WVqkwQbLFD7P+
         O1Hwd+m12Sdd9iW8dRWmYMevyEowBlyBpdTPjDrkes5mcn/Q8yl/FycrsnRql1lhMXzL
         MWDSd8+s55eY4QW4NtWVEXVbH4Z4J/wY7s7XQl++Qu8YRFu2hljnx3nHi92XmYvpOD2Z
         Bu8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739611867; x=1740216667;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=A68stfW/y4+te0SMbEKg7jzS2TB8Xg5jlmvb5fcRKaw=;
        b=GWVgcw/0Zy8vYPevXrdjp8jBH/W1l/ADo2QOu3OJLFIyMb6sLYBFYNmhGUxu5lgF2A
         4yt11hmMRs82mol3lJQBJEVYXvBJPuEHxkqsgLODTPYAv3c7rYJp7cA/vQgswiuFmWXy
         fY+ss4xslP7jee6QPStAWoH67rWYZXWn3vA2ObT3VZD6nGgGjujIYYzYGBdZe4NRJv84
         uKIpBsjOP043ABlePjuc1nez9vWqnvQQVqVe9lGhJu1+ffDZEkFN7K3CtGwaSF2R9yvS
         5Fn7d+K4X0PtRjo1oPu9vR5mTHN10mtuNxSknjBniYwg8wg7lA/bSv83lshVqJma7beE
         s6DQ==
X-Forwarded-Encrypted: i=1; AJvYcCUtEccPS4J3N1Ev5LxiKx1wHMWXWOPHpoBjiLIA0HLVC2h/sGVt7P5/9xsTpT0CDMtzX+Gn8o3Eh88hKrM=@vger.kernel.org, AJvYcCXwQwVyoo28LnqhIvH+XXIzMuHlEutZOZBsoN7JaVcm5dCVMwVEdV032OJ8VQ5FOKhohh41rD4Wns4TPaqSPw==@vger.kernel.org
X-Gm-Message-State: AOJu0YxkMabroZWufiShkOYt9QhU54WU9j5CGpowsMR6D3+drBkkvyd4
	SKZOV4fPWraN2/trGZl98WwSi+F/h6UYJNenbh5DDWWSXYGdcbNm/PFWetKOJhJd4SdXhMiCE9w
	lvARY0cMOWSsMY5ME7mYf9mLE9tRRXzYVjQU=
X-Gm-Gg: ASbGncuJ97HAGev5q24wb9X+uhRrggCz9dRxeR6InYrUpSwxMmRj0L/moeVfwFzXfG6
	lHzANMvq7D7vKIbHLqCbFsvg0uELl2nhPqJciutd49dQFVX9PgrtI8sHjq+AnIWYPKZJiKtbW
X-Google-Smtp-Source: AGHT+IFDyq7BTICtuPlFbwUXPNTpSxuXLUqDuyqao+zFfh+hokLCug3cZCA8T6I4s06Ew5iTDoF0VeyPqz2+Xj/rAtA=
X-Received: by 2002:a17:907:7b8b:b0:ab7:e41d:34b6 with SMTP id
 a640c23a62f3a-abb70dce45amr206778666b.28.1739611866520; Sat, 15 Feb 2025
 01:31:06 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250214215148.761147-1-kovalev@altlinux.org>
In-Reply-To: <20250214215148.761147-1-kovalev@altlinux.org>
From: Amir Goldstein <amir73il@gmail.com>
Date: Sat, 15 Feb 2025 10:30:55 +0100
X-Gm-Features: AWEUYZlVbHgeJgKJ6piYY4JkhJ4foKy4-DEKtmIUJ4H3o_44dqiwN62ARyTikMo
Message-ID: <CAOQ4uxhuN8Bs7yRDKtrdwixzU-T4-fN-SQSRvqT4hEbu0iDF8A@mail.gmail.com>
Subject: Re: [PATCH] ovl: fix UAF in ovl_dentry_update_reval by moving dput()
 in ovl_link_up
To: Vasiliy Kovalev <kovalev@altlinux.org>, Christian Brauner <brauner@kernel.org>
Cc: Miklos Szeredi <miklos@szeredi.hu>, Gao Xiang <xiang@kernel.org>, linux-unionfs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, lvc-project@linuxtesting.org, 
	syzbot+316db8a1191938280eb6@syzkaller.appspotmail.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Feb 14, 2025 at 10:51=E2=80=AFPM Vasiliy Kovalev <kovalev@altlinux.=
org> wrote:
>
> The issue was caused by dput(upper) being called before
> ovl_dentry_update_reval(), while upper->d_flags was still
> accessed in ovl_dentry_remote().
>
> Move dput(upper) after its last use to prevent use-after-free.
>
> BUG: KASAN: slab-use-after-free in ovl_dentry_remote fs/overlayfs/util.c:=
162 [inline]
> BUG: KASAN: slab-use-after-free in ovl_dentry_update_reval+0xd2/0xf0 fs/o=
verlayfs/util.c:167
>
> Call Trace:
>  <TASK>
>  __dump_stack lib/dump_stack.c:88 [inline]
>  dump_stack_lvl+0x116/0x1f0 lib/dump_stack.c:114
>  print_address_description mm/kasan/report.c:377 [inline]
>  print_report+0xc3/0x620 mm/kasan/report.c:488
>  kasan_report+0xd9/0x110 mm/kasan/report.c:601
>  ovl_dentry_remote fs/overlayfs/util.c:162 [inline]
>  ovl_dentry_update_reval+0xd2/0xf0 fs/overlayfs/util.c:167
>  ovl_link_up fs/overlayfs/copy_up.c:610 [inline]
>  ovl_copy_up_one+0x2105/0x3490 fs/overlayfs/copy_up.c:1170
>  ovl_copy_up_flags+0x18d/0x200 fs/overlayfs/copy_up.c:1223
>  ovl_rename+0x39e/0x18c0 fs/overlayfs/dir.c:1136
>  vfs_rename+0xf84/0x20a0 fs/namei.c:4893
> ...
>  </TASK>
>
> Fixes: b07d5cc93e1b ("ovl: update of dentry revalidate flags after copy u=
p")
> Reported-by: syzbot+316db8a1191938280eb6@syzkaller.appspotmail.com
> Closes: https://syzkaller.appspot.com/bug?extid=3D316db8a1191938280eb6
> Signed-off-by: Vasiliy Kovalev <kovalev@altlinux.org>

Reviewed-by: Amir Goldstein <amir73il@gmail.com>

Christian,

Could you pick this up via vfs.fixes?

Thanks,
Amir.

> ---
>  fs/overlayfs/copy_up.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/fs/overlayfs/copy_up.c b/fs/overlayfs/copy_up.c
> index 0c28e5fa34077..d7310fcf38881 100644
> --- a/fs/overlayfs/copy_up.c
> +++ b/fs/overlayfs/copy_up.c
> @@ -618,7 +618,6 @@ static int ovl_link_up(struct ovl_copy_up_ctx *c)
>         err =3D PTR_ERR(upper);
>         if (!IS_ERR(upper)) {
>                 err =3D ovl_do_link(ofs, ovl_dentry_upper(c->dentry), udi=
r, upper);
> -               dput(upper);
>
>                 if (!err) {
>                         /* Restore timestamps on parent (best effort) */
> @@ -626,6 +625,7 @@ static int ovl_link_up(struct ovl_copy_up_ctx *c)
>                         ovl_dentry_set_upper_alias(c->dentry);
>                         ovl_dentry_update_reval(c->dentry, upper);
>                 }
> +               dput(upper);
>         }
>         inode_unlock(udir);
>         if (err)
> --
> 2.42.2
>
