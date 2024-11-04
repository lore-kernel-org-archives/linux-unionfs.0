Received: from mail-qv1-f52.google.com (mail-qv1-f52.google.com [209.85.219.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44BC618EB1;
	Mon,  4 Nov 2024 21:46:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730756777; cv=none; b=GY3mCSQrzkOP+jmyD1ZhowrXw/fRZYT9brEyC3ORL9W7gfwrEmZKfoZr85Kncvd6WKIl05qtLkqM5Klf8jkiQk79Y4x4B2XdFnRoxUU8QM61zcrL9a4t4MLcM34wHISreGtBENPW9L0V7tFkpM63joUpQYgF3keJcuzny3xmB6E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730756777; c=relaxed/simple;
	bh=jQrf2IzB+9baC2AWDlbIQ5Z/capJLji1JhAPGBzczZI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=U9YOhQaXJGx7K6fw1+pcv5PXAMLlVBkuCCStIbB0tQIbLQ3wNvgM0KR7Q8cECoe9w48zcdgL9THH1HIZf1NWHcAXdZBYsDpC48gOd7tUvy3oJDUmPTb+VH6LJHJM1Y1tgqNgAcjH5Dc6eNQaq61yl0pvRc79jPaUI8SqvKRUY2c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=aqwh2TOQ; arc=none smtp.client-ip=209.85.219.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="aqwh2TOQ"
Received: by mail-qv1-f52.google.com with SMTP id 6a1803df08f44-6cc03b649f2so34612056d6.3;
        Mon, 04 Nov 2024 13:46:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1730756775; x=1731361575; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=oySQVcyxJVglp4lRm/JqHPvjAGIdg8A9FWd8akmI8B0=;
        b=aqwh2TOQq7cq0BHPJfD5vRTRBiTYk8jbDaZIQE77BFJ0x0ho2+x33Cmsx3WJanMdTo
         zBpNPEuYYZcjxDgtLP73h8iu03ySfkbRx2hkuPBNVB+p+GSMZC976MawmN1YmsFQzKy/
         IfLqIcA6tJ3pziZI/lMbE9OVeaFG/gQvpcInson6HxfWURS6ywlpGKzUi9RZjYPjdWxw
         ndPuU2CNocUKFIsDF0frLe0LjLlr75Hit8ZqHoRQQEPoeK86TE1whbovEe9+xg07A2mM
         QxFkx2y75+O/cczcCeriW6M5PkCLXWJEpmebgmAepX522oWeRhgxhhriH/Knrcj0KctM
         PADQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730756775; x=1731361575;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=oySQVcyxJVglp4lRm/JqHPvjAGIdg8A9FWd8akmI8B0=;
        b=gW7qCRh7p8ltB0bdUqcac2/xtXFmNVl3JUiwHzszQpWBhPltva/yVNHtsgqb88xTaq
         TAnGuQwve5ZDovEUJOgd8QnT5/Zj7WB4XMgT3ICUsV5WtdKmSdhfJfXXuiNn+brgdQ7J
         59Q7O8kO/BCT1xYsPNfc8ek8zxbYyFlP2IKOLSda5pxLi5J53aaGr7lEF7YBkktK5M2G
         SURsu0/klNZcTj3peblNdlY7hXOo4ysgIRCXXSI9V/MCqXpIN/4qQuLHmzmf8zkPoHOX
         QlZXmhjilLiBdnb4ltIh5HCbnPMpIzn3LoRW7Gn1o1lQu8xJMYSef37zEjamXh0TJn2/
         VbAQ==
X-Forwarded-Encrypted: i=1; AJvYcCUoflnJLFnUugmuqKhCob4JUsmh1197uakDWs7w2OMHdSxh4kdTa+DSLV2eBg4l/36eaj5CSxjgQLPc+c47lA==@vger.kernel.org, AJvYcCWNAZ/OI893IywAuMQNAsis4gcy8KPWrGv77rNysgsqd8Abd7aBP38tZTYKOLCx+zI67usyiZvUUZBI7co=@vger.kernel.org, AJvYcCXRKHhbXaaTOUYJnZSjPy+0qeMQhMQKDWx40bDb/6n634dxLOiRwiYSuP7mYn3+VNlN7Fq+HSnB@vger.kernel.org
X-Gm-Message-State: AOJu0YzLgurno9Llpl0A9G7StzB616LL3Z8SHTMdZ8boIwOzTSHjhMXT
	Hjmp8iTPPyNe/gCDsDqeyjTpthsmeA4u50my3RKMEd/aC+fmvSfaxJcbC2twQOg6aQlLKMBC7G1
	1A5UEU+pbqrwMiOsZlPwoh24cJEg=
X-Google-Smtp-Source: AGHT+IGH1021JFcmTnLwpVIFDUO1OGNec/ftzrIXcEEuDIUhRueOKVPBg6x1N1AsqBoHeUJ/MvRTBIcKRX4KCon5N6A=
X-Received: by 2002:a05:6214:459f:b0:6cb:460c:61dc with SMTP id
 6a1803df08f44-6d351a935f3mr302531946d6.11.1730756775045; Mon, 04 Nov 2024
 13:46:15 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20241030002856.2103752-1-ovt@google.com>
In-Reply-To: <20241030002856.2103752-1-ovt@google.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Mon, 4 Nov 2024 22:46:03 +0100
Message-ID: <CAOQ4uxi_TxU2Kwa31h0LYYoMyUq2kpM0CGpfFd+0Yc158yDgzA@mail.gmail.com>
Subject: Re: [PATCH] ovl: properly handle large files in ovl_security_fileattr
To: Oleksandr Tymoshenko <ovt@google.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, stable@vger.kernel.org, 
	Miklos Szeredi <mszeredi@redhat.com>, linux-unionfs@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Oct 30, 2024 at 1:29=E2=80=AFAM Oleksandr Tymoshenko <ovt@google.co=
m> wrote:
>
> dentry_open in ovl_security_fileattr fails for any file
> larger than 2GB if open method of the underlying filesystem
> calls generic_file_open (e.g. fusefs).
>
> The issue can be reproduce using the following script:
> (passthrough_ll is an example app from libfuse).
>
>   $ D=3D/opt/test/mnt
>   $ mkdir -p ${D}/{source,base,top/uppr,top/work,ovlfs}
>   $ dd if=3D/dev/zero of=3D${D}/source/zero.bin bs=3D1G count=3D2
>   $ passthrough_ll -o source=3D${D}/source ${D}/base
>   $ mount -t overlay overlay \
>       -olowerdir=3D${D}/base,upperdir=3D${D}/top/uppr,workdir=3D${D}/top/=
work \
>       ${D}/ovlfs
>   $ chmod 0777 ${D}/mnt/ovlfs/zero.bin
>
> Running this script results in "Value too large for defined data type"
> error message from chmod.
>
> Signed-off-by: Oleksandr Tymoshenko <ovt@google.com>
> Fixes: 72db82115d2b ("ovl: copy up sync/noatime fileattr flags")
> Cc: stable@vger.kernel.org # v5.15+

Applied.

Thanks,
Amir,

> ---
>  fs/overlayfs/inode.c | 7 ++++++-
>  1 file changed, 6 insertions(+), 1 deletion(-)
>
> diff --git a/fs/overlayfs/inode.c b/fs/overlayfs/inode.c
> index 35fd3e3e1778..baa54c718bd7 100644
> --- a/fs/overlayfs/inode.c
> +++ b/fs/overlayfs/inode.c
> @@ -616,8 +616,13 @@ static int ovl_security_fileattr(const struct path *=
realpath, struct fileattr *f
>         struct file *file;
>         unsigned int cmd;
>         int err;
> +       unsigned int flags;
> +
> +       flags =3D O_RDONLY;
> +       if (force_o_largefile())
> +               flags |=3D O_LARGEFILE;
>
> -       file =3D dentry_open(realpath, O_RDONLY, current_cred());
> +       file =3D dentry_open(realpath, flags, current_cred());
>         if (IS_ERR(file))
>                 return PTR_ERR(file);
>
> --
> 2.47.0.163.g1226f6d8fa-goog
>
