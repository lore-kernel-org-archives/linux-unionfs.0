Received: from mail-ed1-f53.google.com (mail-ed1-f53.google.com [209.85.208.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86D7B29D29C
	for <linux-unionfs@vger.kernel.org>; Tue, 18 Nov 2025 09:38:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763458736; cv=none; b=YqT73wEYy3otwXAo32a/DLr7y3RxsCFc4HODkafrayHBMkCuxq+s8P4FtWGWmBrc7qMnrfvl58VZnLIWQPwUenvtZgkP/b8wRRA0ZSP2ozLMc53SjWD62z0FkwmP9qpgFJKYsCO/r3soBWmvS3rqY0H9dZFbH3rD3Ni1XRt/I/g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763458736; c=relaxed/simple;
	bh=1WdA8cRFaIuoEPlnHUR3016BXYk4T2U3XrTC78YONno=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=dFqqK5UqtK/wGyDci7aiL4hqLKzMGaJVUrLAIUH0gfQ7GhYeLi+1JrVZshcjDZA+tpt+pE0JBpGl6O2XS28NNCoNaIBXEgRVmqiOCOt943kAutqLyMHFd3FHvXufSrJfD6TbH2tFYTptu3P2udTeWyMlSD6+7AWJaUSJfv+foqM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=f17Iq1P+; arc=none smtp.client-ip=209.85.208.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="f17Iq1P+"
Received: by mail-ed1-f53.google.com with SMTP id 4fb4d7f45d1cf-64074f01a6eso8885146a12.2
        for <linux-unionfs@vger.kernel.org>; Tue, 18 Nov 2025 01:38:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1763458729; x=1764063529; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=fzLfKX0ktZQacVfDl6RZ8y84bhKFdeZTSQQaNU4vUcY=;
        b=f17Iq1P+x66CDLfSYgeQJbfVYd8+P0TI8wocLwawZrPQCKqZFGkH2l7e8Io5qOMaV3
         U27J0IU1nE2D7TXSAlsXi88rk9s0UyB9XA1D7cYNa30Q3Du/lIbqoDQiASQElXry73QM
         cfCGljf/DdTIshtEYMFI2J9fKhUHPk9dwCs7CjWgCZEYvOoiLAQk9NHZfjAJWndSLeMX
         odtkl3+skxJbAnVtDmtiLVfASqOCiVhs+IrJqndu3qQaP8IyUFC7CLHNwVeHFyZBj5IY
         e/nXDAo2J5EB0DGvPDGWKHNXQTX+0YeZ8xC7vV94+bSC4h6UUdPjZ8EbxEw3evRCBz1y
         5/Ng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763458729; x=1764063529;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=fzLfKX0ktZQacVfDl6RZ8y84bhKFdeZTSQQaNU4vUcY=;
        b=aXdu6zRBvdrcdqgeP4cDzs7dZsmABA+ZKOPB7Sf9xtIE2sZgne1IuYUGGSo9CYQ0Ac
         nqKSX+QuzTU0H8QQ9oypWOWirR78TIsGwwikzp+grBDCNXIyFO4In7bWSIKxWxaZ9aTP
         MEGViqf6hl9UzQDmkoX0xFMPjJvrt0OX4eCaWXMtY0LtWkY6di1E/MP5w9BdqQXtQHsC
         V0N2Mj8eRV+/KQKUQvH/ECasH6QClgBfbIiNJ0qNJ6B/LtzBIVXmbajSl6EAc/Lscc8C
         4aIoKbA46P+9Q/kbbynlYw0TnMczR+zbZ+6vV4lsPTK9+Wo8mevovAj/7NG8eGSCJ+Nr
         VhOQ==
X-Forwarded-Encrypted: i=1; AJvYcCX9+mqcNxymem36jLwu0wsQtdvMmmflgqOpIw6ZmmqPS1EglhFFBiqClg+Q2zQbN++ZnGFgi4htJGh9mPc9@vger.kernel.org
X-Gm-Message-State: AOJu0Yw3NKCh6iwTWtUQceADGN+VwlZNtY7vzdcAtfv8uFATtKNd5+gS
	Bu9vlZG0cdOSTS3XqDbvtBo5vScgD4vE4vtit/JCfqZ9q5QpxJkQDmw4yx2WELUd5/Is26vPBhv
	yOvhUibohNTxvZybUDzK6w0O6nsaBS3w=
X-Gm-Gg: ASbGncsMdZKjce7a0nWy4x8OPheqrJTaoy6IkCsfLFQUMNz3nbXfBz909DjMlli4zmr
	uKYkYJ2hnK1O6Ngt5DJf9o8bEtS46XVXlURrGykT3RH/mOR+/5C1MGZoWhvhYQvkD1d2zI5RO/r
	B9u/vxsr3rL8hvu7NLcjXF69UaXODk+rTo5qCUYFxHn7b9G96JQ5C87JCvqKKZMyK+AV9MWanUC
	MH5HdsF4Xf+qKah+TLTP+VMSyYaqYQthU96PaydGluJRdCMkRxX9BirGqrbGDbV/Bfxj4BGMTgN
	QLqIX6dUHjWmIsxODFm7wNCpP2dr
X-Google-Smtp-Source: AGHT+IF6g7Hqf1IybPPkfVPKQWf8Eq0sqxAnBFBu/i/nks4Yhse26o/DP7Sv9bYAQHayndw14GP2/kTWOMe1ySx4cTY=
X-Received: by 2002:a05:6402:1d49:b0:640:a7a9:289f with SMTP id
 4fb4d7f45d1cf-64350e04fb0mr13197503a12.2.1763458729087; Tue, 18 Nov 2025
 01:38:49 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251118024800.701780-1-nichen@iscas.ac.cn>
In-Reply-To: <20251118024800.701780-1-nichen@iscas.ac.cn>
From: Amir Goldstein <amir73il@gmail.com>
Date: Tue, 18 Nov 2025 10:38:37 +0100
X-Gm-Features: AWmQ_bkiqSeu8BdbWNpu78_b9Ee2qfsNRycQJsAxp7Qqi7b2XZvICcBJ0t-c02M
Message-ID: <CAOQ4uxh3YU-Ksx8gMA37YBXY-J=NnLDfTjfrdDYUU-1q3=SE7Q@mail.gmail.com>
Subject: Re: [PATCH] ovl: remove unneeded semicolon
To: Chen Ni <nichen@iscas.ac.cn>, Christian Brauner <brauner@kernel.org>
Cc: miklos@szeredi.hu, linux-unionfs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, NeilBrown <neil@brown.name>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Nov 18, 2025 at 3:48=E2=80=AFAM Chen Ni <nichen@iscas.ac.cn> wrote:
>
> Remove unnecessary semicolons reported by Coccinelle/coccicheck and the
> semantic patch at scripts/coccinelle/misc/semicolon.cocci.
>
> Signed-off-by: Chen Ni <nichen@iscas.ac.cn>
> ---
>  fs/overlayfs/dir.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/fs/overlayfs/dir.c b/fs/overlayfs/dir.c
> index d21f81a524f6..7c2407b8c3a4 100644
> --- a/fs/overlayfs/dir.c
> +++ b/fs/overlayfs/dir.c
> @@ -105,7 +105,7 @@ static struct dentry *ovl_whiteout(struct ovl_fs *ofs=
)
>                         whiteout =3D dget(link);
>                 end_creating(link);
>                 if (!err)
> -                       return whiteout;;
> +                       return whiteout;
>
>                 if (err !=3D -EMLINK) {
>                         pr_warn("Failed to link whiteout - disabling whit=
eout inode sharing(nlink=3D%u, err=3D%u)\n",
> --
> 2.25.1
>

Hi Chen,

Thank you for the report!

Which branch is this patch against? linux-next?

It fixes a typo that got in with this patch
https://lore.kernel.org/linux-fsdevel/20251113002050.676694-5-neilb@ownmail=
.net/

Currently staged on branch vfs-6.19.directory.locking in Christian's vfs tr=
ee.

Christian, do you want to squash this fix?

Thanks,
Amir.
