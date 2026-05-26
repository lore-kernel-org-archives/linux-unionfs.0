Received: from mail-ed1-f45.google.com (mail-ed1-f45.google.com [209.85.208.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2FAB63BD64A
	for <linux-unionfs@vger.kernel.org>; Tue, 26 May 2026 13:54:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.208.45
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779803666; cv=pass; b=GQH7z7byLA8QyionnDiJUYVvh5TiSfqjKD9bvojpYeq/FHE/JGc+WrBamlMle06GhfNOcNX90Y10Pp//E6lgKWN5J5M8Z8+MooUXsMYQBk8iUUkFDpiwKiHD62CbpJ7gAxOYSBh2rw6uRqfoLun5NzRraTI9vU0vBIP0pnq06Is=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779803666; c=relaxed/simple;
	bh=2TU/HPcEgwxzGQTeQxAZwmkkDFE6M0PF19H0oFnmVzU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=fmwmFavadq6494X7fu7nSq2abitoIY3U5oJGSv4ES86lxDK6aqBYMDj43POJ4uP0c/OBJu7q5ogO9laKbo4CvcdK2Sdq9PgE+GXCKv+EyTAdQ+wByXgZzKDxlQPdAP3hl2ePrADKCtyynXNKtOMrnjlviTwdtF7NMjZX4KzhkRU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=T4Y2/jTR; arc=pass smtp.client-ip=209.85.208.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="T4Y2/jTR"
Received: by mail-ed1-f45.google.com with SMTP id 4fb4d7f45d1cf-687e7edaafeso6547767a12.1
        for <linux-unionfs@vger.kernel.org>; Tue, 26 May 2026 06:54:25 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1779803663; cv=none;
        d=google.com; s=arc-20240605;
        b=HZzfRpLj+UFRHt7yjnQghXlev87cmhdDWVUs4goKXmPxNK9ZSv8x8Vu04L73x2l1QI
         ItDoaMlaO6EktjxXDVBA4dzsSRkIuEn+yHWN0llU7TwokoPJdgqeSLUbByRmvyQ2o3jM
         AWbT+wryTunk3Q1b3tNkCBTtM4T6DPxPbZaNU06hRyoEaKIcy4EOoEOVuS8d+OUgdoiC
         3PxhRRKLVGTJgmOXWaHRCoFtXEBxyKGu76G3MQv8f6NUTgeKGiv7+d81xQaQl+XPk7xI
         qeUAkcGVQllDqA3AG0Y+LlR6J4jG7lxuhqx7ospnLQtIRCATgD+3RQmEznn1+QEBq0du
         GGvw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=BEx7uN02jNK0071tFe2UGZXPwPcQj21lMaC8f8ui6K0=;
        fh=NF2148qBkbClrLLgSSfLKcEm8ZGhhwAcutRI5L8xl8A=;
        b=KXKLuYlUz3LaWHFxk4YkjwSSAbTDetXC6IR9NntRn4rEI7VqdTVdhyUrja13rj6rKQ
         Iwa6wenmkuqHhbRL0dM00EsppSh+ee8871NP127Fawv0A/Ba4Q5nkC5JLW+UlZkuYuoG
         fUBwrigS2U0JwdzyBEl12pahcNaSPcYo/M+WDlCopmjmeL6BHHO1zdnH8T2Hc6893tzu
         st93Kq6IM3ybtKXHdbyiM9ON7mCOJTGFHmcPPqMEBCud2S5gbzVEEyGW8PhOxw6PuuyA
         gKU5uvluU0iVn5qiHO9VP84yCu4auyCKSveXYAEVRfkD/Qd5AbwuNi3TK9W+dx6qieuO
         4x2A==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1779803663; x=1780408463; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=BEx7uN02jNK0071tFe2UGZXPwPcQj21lMaC8f8ui6K0=;
        b=T4Y2/jTRyylmo9wqgpwlNbyboNQ2KXdcGEhN9X3P+RmcXKY1ZPCmL5+g+n7h1awslR
         XTWCH1VcCZDnJdtM84xWClR73PguD4RYJt2zf0D/upQYnz43swiT2/g/lchhLsr2OyGW
         E60QRzuh9T0oMFwEpXyWbWYx0l8yS1DHXwQ9Hi6JzGC+jA7w5lpRw+2Xo98rA1WFAPMS
         LNPrIIXWIxvYJGygvOfQ01yZZUvI/XraXHdZVF92GlnPKDop5SeMVhcqc75s8Hpm/f+T
         62rermOWRy1vxtMZHX9rZvJMiSFZsaTpgiGqWWaAnoBUhggXVaCB9vWGVsCd0KamBFEk
         1PKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779803663; x=1780408463;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=BEx7uN02jNK0071tFe2UGZXPwPcQj21lMaC8f8ui6K0=;
        b=nSqIILrrJVJqkrF109JKxsNyAYPVceTU8WpsXOthQsF1R2AYhTb9eodLhH6zGJRUA3
         mWd4BEc4iKKYYhWbJViqrIyAKDKrHgO6RTrl7DsmZSqYLACVVvptNpDv4HG3YCKB0Kc3
         nAcZQrn2DGiRLmz/2+miUqC2V8ECpIWqQcurOUo9ywhFB1Q0X+HTcQETwGXxvegFKsaS
         hR0oUPc0i0Y3TWfmLox6v2qgrKQlrLRr+OauYf93VPRMuX9IT80MbOPGb/TA5sdaPlgg
         YhNUEJESWzw17E++UsvTXZktTuTRJnDI9+YJdZ8HsWqX2f/EAcZvqX11yL/DNC+JF1K+
         SbyA==
X-Forwarded-Encrypted: i=1; AFNElJ9/PYKIH12rOvzys1yWFmUS/Y3IHS/GcWAkKd5G4hzKKJ8am3CHdW0AP6WfMOg9Z4FvO9x1tAh1okf9Wknx@vger.kernel.org
X-Gm-Message-State: AOJu0YyhwLHY6EbVsWCAFanPxI4BgCFbwQMM9/uMQdTkmwN9j+U3Ohku
	k5sBSTCIEp5nTlaLmW4emG7W/6EgbsQb3AKH147sI3QoVcK0sZzA/Y4Nftx2SLXuRRXXzpiA1sO
	UlxbBwMg15hssJU/7MoVaU/tqj9gXPHp/bPPwpX4=
X-Gm-Gg: Acq92OHXCbRQaUazDoD7NZx32RMoh+Arup4CbbIOTEukBGzpFi2FYpURGoKHbRXaBNj
	9D+bZkTUFQIUxCkwHij55gdqM6i/ld/totsta95yXsV2GnGAMvXrb74PN24KO2CFU/KoAgWXWi5
	7TrgFDdf1OS+9uxJ17+8SsiBOWvy3ICNjLY56AM57iJ8XVC0I6kEEbIOBHLwqYX9klo634xjfSJ
	hw5ed8IdwnbQDe/7GdRZq2Ihrgtua9q4zgkO3svjdGOdnvud7w8nHVDw4SJdxU5RWt2qM4Xv8eA
	HJMGjGWT2lCYvxdysD32/c/BB4svXH2rBx15Ps06DuMWWkFSOPE=
X-Received: by 2002:a50:c8cb:0:b0:689:9706:cef6 with SMTP id
 4fb4d7f45d1cf-6899706d66bmr3424863a12.4.1779803663440; Tue, 26 May 2026
 06:54:23 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260526085801.81187-1-liwang@kylinos.cn>
In-Reply-To: <20260526085801.81187-1-liwang@kylinos.cn>
From: Amir Goldstein <amir73il@gmail.com>
Date: Tue, 26 May 2026 15:54:12 +0200
X-Gm-Features: AVHnY4L62fcz3pAXF35UOsshoYtTDxjRAro6GJAMnrkVCJ_cwC0OIGhuqi7h6GM
Message-ID: <CAOQ4uxg_ODc1NLU95L4EAD5MT7ZqYfsFKKhgJ+YXud_zZZJCwg@mail.gmail.com>
Subject: Re: [PATCH] backing-file: fix backing_file_open() kerneldoc parameter
To: Li Wang <liwang@kylinos.cn>
Cc: Miklos Szeredi <miklos@szeredi.hu>, Alexander Viro <viro@zeniv.linux.org.uk>, 
	Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, Joanne Koong <joannelkoong@gmail.com>, 
	Bernd Schubert <bernd@bsbernd.com>, linux-fsdevel@vger.kernel.org, 
	linux-unionfs@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, May 26, 2026 at 10:58=E2=80=AFAM Li Wang <liwang@kylinos.cn> wrote:
>
> The kerneldoc for backing_file_open() documented a @user_path argument,
> but the function takes const struct file *user_file. The user
> path is derived as &user_file->f_path.
>
> Update the @-tag to @user_file and adjust the description accordingly.
> Also fix the "reuqested" typo in the old comment.

typo: requested

>
> Signed-off-by: Li Wang <liwang@kylinos.cn>

> ---
>  fs/backing-file.c | 5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
>
> diff --git a/fs/backing-file.c b/fs/backing-file.c
> index 1f3bbfc75882..a530c2d19d20 100644
> --- a/fs/backing-file.c
> +++ b/fs/backing-file.c
> @@ -18,13 +18,14 @@
>
>  /**
>   * backing_file_open - open a backing file for kernel internal use
> - * @user_path: path that the user reuqested to open
> + * @user_file: file the user opened on the stackable filesystem

@user_file: file the user requested to open

(It is not open yet)

>   * @flags:     open flags
>   * @real_path: path of the backing file
>   * @cred:      credentials for open
>   *
>   * Open a backing file for a stackable filesystem (e.g., overlayfs).
> - * @user_path may be on the stackable filesystem and @real_path on the
> + * The user_path (taken from @user_file->f_path) may be

@user_file->f_path may be on the stackable filesystem and...

> + * on the stackable filesystem and @real_path on the
>   * underlying filesystem.  In this case, we want to be able to return th=
e
>   * @user_path of the stackable filesystem. This is done by embedding the

the path of the stackable filesystem...

>   * returned file into a container structure that also stores the stacked

Thanks,
Amir.
