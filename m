Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.208.49
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794754132;
	b=NWUo8czBiyRvdgRAZT/vnskdZnVyCAiKEazv8E9NuDyJd48v1tmKLh49Z7Ej1ckVMfQe
	 qYq/jJc21am61xidJE+Tv68wCEa+OvIFGqglDbLDyG3EPNcPpfLKnbX5GoJfmk4g3y1zp
	 kw+xKhFGY2HKljesfqPXm0QYnh+Zv8c08S+Ix1Xm5UD/ijm9H4mHrLiZjlgJcDfTGLeKy
	 /tSc5itTsnNyUA+1AkrWvGhtaFWx9NDEF4fFdknGy853T4vtbusySXo2/vYaBQ3zRVo6S
	 uYGDfw7n04XfonONx55rDjq4JrZN+qtbewrPDLqlTVqAnihlt66Fz7PqMQs1v7+u1GQ==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794754132;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=C4gZYNSTU3nUDa0BlNRCYypUaVksPX6JgKJOOi2udkU=;
	b=pY4u9dU19lzFqnsu+chG6cekkUNTD76ra6BVgmcGU45xI2Rl4o5PKsdF94EPMTSksgns
	 85Cg7lJnzZF36J1OpMZhIF6RNKPkGtUvI59+MCPTxlJdAsHg4LPqkMCCOEzxolqg8SDsh
	 EPTAjf6D8UNZmQFrYp1QS8w1RcGvyYPAQZcX6Bg0/jvodFqonvKiaihrgKYRwhIz6g7oD
	 KyTPXcyCWqgICLCCxBvxYGbvi0zHi0so/PeZQZ+a6hqBPkQyGyGPHT0GOY0IsUzbBg2vM
	 wqnLiyUODeOUrGRj+E6kBx76xdjZFoOvcSUiBYN7LgslI60fsBzt058jlqhVIsuAPdg==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b="w5g/XQ3c";
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.208.49
Received: from mail-ed1-f49.google.com (mail-ed1-f49.google.com [209.85.208.49])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67B94606A31E
	for <linux-unionfs@vger.kernel.org>; Sun, 15 Nov 2026 14:48:52 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 67B94606A31E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=w5g/XQ3c
Received: by mail-ed1-f49.google.com with SMTP id 4fb4d7f45d1cf-6b577addee9so4278937a12.1
        for <linux-unionfs@vger.kernel.org>; Sun, 15 Nov 2026 06:48:52 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1794754131; cv=none;
        d=google.com; s=arc-20260327;
        b=mg0/w2XIm6n4ccGqfaCHYtGKddgz9SGQhnS1rOnPkoQ9K25N19zinmDTA9/+wHIdtv
         3zntvVbYlbe7ypF/vxRi9ZBwjQtbb3lX2ze1sS53ZuLis0jEc7qvcDGf5s4Rj+UK525s
         BxjvfY9LZEYb6OvzovQrC8cVOGHuVUey/3nFnHmvBTuwSLRxGBmc+t2JDuAMo4oTTvzQ
         MutDsqkw5301F84HAo8/yuEAlX30sVJKbXRaVwQ3sUGRXjw4JVKiob6lbMFLWauKhZ31
         zIDclxjyZw+zi3HmGGBJ1DkhsxfAWv5P+aNjNE+Cpq+NQ17MucC8+LXvEybxWwkbHB/J
         c7SA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=C4gZYNSTU3nUDa0BlNRCYypUaVksPX6JgKJOOi2udkU=;
        fh=0BD11McnuI8Ipvkz3bA4veKL40eHhkQC2XhPldFG+CM=;
        b=fK6Kij/z2FDhhUl8sn34pq+ZO5otVvp2KGM8jFa1RA3EOh4aYsJY0ATTzrirTco9YS
         ApP5/oXQ3U+gKyLME3ZoiXnBPFuqFzcJq8yX7LE8tMPOkdpkR6bahaBWu0p+giDRlq3A
         NTRYz5QF0vH5zP43kpT7sUG+aOZHxPcDdM/mX2TyeYN3UBxS/8qyR0IvDOv7rR5WshKl
         m69YjZR9poon3ILpKRn3U1w0PCtBdSShle/MuCaSZ2gNaOHIitJeNJlxZ0svERgpeWPC
         qPetKAwgoLiU4C3vRnvp8kQqSLbjITJICmxKgcW3XXOeQDHUIgK+7JFYJDs0VoD9hOEv
         Sduw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794754131; x=1795358931; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=C4gZYNSTU3nUDa0BlNRCYypUaVksPX6JgKJOOi2udkU=;
        b=w5g/XQ3c9k+Vmzjr8H8faYY5EnV44gyfCeTqkUEnB7IDVxBorehzGxTmotRUcFMd2k
         yEd9UzOdm44dKGOB9vhvuqA14zDF0izirGlMHcIkPmvfAWV6oC7EWoZSr/n7pMgjOayy
         4XbbykfX2tOLXKQEY71fD4ubWMAf5smyh0PUCbn4ouKSDid+wdpti8tnvMNzC9U0omm7
         PfP/4oysMFjcZt/QSyQgeX6xWgKvlNh0WDaR4PRzqjFkBPghAucojPZwp0HxO1dsPk5w
         0TrSxGukXHJtQczzx+u36Zh+VEpUmtRmnvhCaIPp54UmNZzIkin7PEC6+n43usjPmyxQ
         Zqdw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794754131; x=1795358931;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=C4gZYNSTU3nUDa0BlNRCYypUaVksPX6JgKJOOi2udkU=;
        b=LVmom3bor1Tgp7z5qTlyY8u4yQi4mjd9R7gFC72bqVwv8+LUUCpmjfFHG3nBxAwNVu
         Ov1TEHEqWfpM1cYuEUsdjVmlVJml24NnE7/B/ZubrBPLctJ85WsqVfix+PLAk3VYchFn
         l7HgwHrFamU3H7V1DZN4J7i94IU/H52UAIuKfI3ZjNl12aHIgSXGOj8PWc2dJtoXA8TA
         XmniMJqHYwif05dRigBKTCjJr4umoqdw7HxmECa7hBP7WoxQmzaNTIfo/oiLWfGviArl
         4K7PPXPVwK2Cmr2SQxP3fez1Zj1mMF91G8V2lOLGmOJOz1NQsVLw+aYRZIpxN3h9Q/yk
         rynA==
X-Forwarded-Encrypted: i=1; AL+hErHJbVobhGBaNfxtXEYQ3CKohsdncGNvbWyrrob8XtGEKtBX3vkwvMszHR+ra9RfZoNUwF5s04jI/pKpuqt/@vger.kernel.org
X-Gm-Message-State: APuU4Z+X/5TL34pmR3xmEChOff/seFk497k3lRtd6l/z5zaqWr2zqWei
	acNMoAq6iAtZptZe+B5SrCppX9mpwey+aVhZDAiDOJRDqADUsSNafNqaI0/qaOgnR3t84yCjot3
	m3Q/XxjDTYMHjQNFBQAlWngrXPC6LmXk=
X-Gm-Gg: AYBFou3kPRZy7CC0sLrOjQP/KJwZl+nMNbmegV5mRXKpEjH0IjWTVczRn++6Z8JDvEr
	O7m3DvhvWU6DHkhvGdhzGs2DUrASc4FNTk5hXaDZAhaa3vQ5rQd6vbYvJ3yb0GX3iNGxXWcGUNh
	CFytxKITfSYqthQd5jn6nNrnayh4dwFe7hz3w71shKopwp3nXjKNRErs3+nVETLxiZxNs73U/nn
	T9ub8YmTmpXDD/oRQVwRQUgXSc9TTFxY3m8Dxp/SSAKERdxwa2DXagLSIJuQUq9N0BF35/vr08F
	9fuFuuV2QZIvf2Mf2gJnYe4qaCetmKpyyyrWX0XyckuN3VmRnZsNtBriu02P/CaJxqe3Ae0C536
	MsJeq4vJv3OXfhaf7q7YnZYDl3BoRcMLcNi9TpDpkQjvDVGZY+OZDOlNNrVah/wRFzNfu+A==
X-Received: by 2002:a05:6402:1944:b0:6b6:edd7:790c with SMTP id
 4fb4d7f45d1cf-6b7c0d2c969mr5932123a12.45.1794754130672; Sun, 15 Nov 2026
 06:48:50 -0800 (PST)
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Post: <mailto:linux-unionfs@vger.kernel.org>
List-Help: <mailto:linux-unionfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-unionfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261115-work-ovl-d_real-v1-0-ca155efbcb2e@kernel.org> <20261115-work-ovl-d_real-v1-11-ca155efbcb2e@kernel.org>
In-Reply-To: <20261115-work-ovl-d_real-v1-11-ca155efbcb2e@kernel.org>
From: Amir Goldstein <amir73il@gmail.com>
Date: Sun, 15 Nov 2026 15:48:39 +0100
X-Gm-Features: AclHuK_loWLpZnEsR5-ArAPNE_f3U8cZmm7GbEpqPveHBdFtxvcWfTtvtccYOKk
Message-ID: <CAOQ4uxgiwKsadtv1Me3ZkSsTawjNey3wDDWVAnx6U0+Oe+uoQg@mail.gmail.com>
Subject: Re: [PATCH 11/13] fs: remove d_real_inode()
To: Christian Brauner <brauner@kernel.org>
Cc: linux-fsdevel@vger.kernel.org, Chris Down <chris@chrisdown.name>, 
	Miklos Szeredi <mszeredi@redhat.com>, linux-unionfs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, bpf@vger.kernel.org, 
	linux-trace-kernel@vger.kernel.org, linux-integrity@vger.kernel.org, 
	linux-security-module@vger.kernel.org, linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sun, Nov 15, 2026 at 3:02=E2=80=AFPM Christian Brauner <brauner@kernel.o=
rg> wrote:
>
> All callers have been converted to d_real_data_inode() or
> d_real_metadata_inode(). Remove d_real_inode() so that any user we
> missed, or one that gets added in another tree, fails to build instead
> of passing an ERR_PTR() from d_real() to d_inode().
>
> Add a porting.rst entry.
>
> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>

Reviewed-by: Amir Goldstein <amir73il@gmail.com>
> ---
>  Documentation/filesystems/porting.rst | 10 ++++++++++
>  include/linux/dcache.h                | 13 -------------
>  2 files changed, 10 insertions(+), 13 deletions(-)
>
> diff --git a/Documentation/filesystems/porting.rst b/Documentation/filesy=
stems/porting.rst
> index c38f5df755bb5..28a24b702f2a6 100644
> --- a/Documentation/filesystems/porting.rst
> +++ b/Documentation/filesystems/porting.rst
> @@ -1422,3 +1422,13 @@ helpers take a const struct mnt_idmap *. mnt_idmap=
() and file_mnt_idmap()
>  return one. The idmapping is immutable so nothing should have modified i=
t
>  anyway. References are taken and dropped via mnt_idmap_get() and
>  mnt_idmap_put() as before, both accept a const pointer.
> +
> +---
> +
> +**mandatory**
> +
> +d_real_inode() is gone. d_real() can fail for D_REAL_DATA now and return=
s an
> +ERR_PTR() then, e.g., when overlayfs can't look up the data of a metacop=
y file
> +in a data-only layer. Use d_real_data_inode(), which returns the inode h=
osting
> +the data or an ERR_PTR(), and handle the error. Use d_real_metadata_inod=
e() for
> +the inode hosting the metadata. That one never fails.
> diff --git a/include/linux/dcache.h b/include/linux/dcache.h
> index 5b3b34d271bd0..2b15179e9baf9 100644
> --- a/include/linux/dcache.h
> +++ b/include/linux/dcache.h
> @@ -654,19 +654,6 @@ static inline struct dentry *d_real(struct dentry *d=
entry, enum d_real_type type
>                 return dentry;
>  }
>
> -/**
> - * d_real_inode - Return the real inode hosting the data
> - * @dentry: The dentry to query
> - *
> - * If dentry is on a union/overlay, then return the underlying, real ino=
de.
> - * Otherwise return d_inode().
> - */
> -static inline struct inode *d_real_inode(const struct dentry *dentry)
> -{
> -       /* This usage of d_real() results in const dentry */
> -       return d_inode(d_real((struct dentry *) dentry, D_REAL_DATA));
> -}
> -
>  /**
>   * d_real_data_inode - Return the real inode hosting the data
>   * @dentry: The dentry to query
>
> --
> 2.53.0
>
