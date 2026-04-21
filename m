Received: from mail-ej1-f50.google.com (mail-ej1-f50.google.com [209.85.218.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C4F33AD52D
	for <linux-unionfs@vger.kernel.org>; Tue, 21 Apr 2026 09:46:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.218.50
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776764770; cv=pass; b=OHsjP5EwFIu2lDevq9N4DbWiMsHA5zcjYGzeep9lcFTl/u9562L8KVd96418hDR23cE+Ti0f08pOAEvYT1S8UzVfNeo1QWbTS75NcHeCxT0d2eeCh5ZmHYCVEVtTAwjJjVeAeyKwDaVDBrnriFCW/tez1zP/XQhO2rnLbfASwj8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776764770; c=relaxed/simple;
	bh=znvspuC1zpa83aqAkhzFcDOyqVdZBRrdnEBNSBvSWzc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=LULDD4c96frG+z92Kmq5Ilap+mGQNzqEaPOHmBKwpzrWaAsEPpJeTEc91aL6L8hR8+io5NXcZ741Zv1WKZoHnTxcAQmYfodxkIQv5BKUac/RkOIA7pPiUZQOhkXVbWcUWHf0Z0nTFqHyN0kXgzYTJrjNlHmUFDAAJ2Hd6BnkC/8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=hsiqrTdE; arc=pass smtp.client-ip=209.85.218.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="hsiqrTdE"
Received: by mail-ej1-f50.google.com with SMTP id a640c23a62f3a-ba6838e76f2so303375466b.2
        for <linux-unionfs@vger.kernel.org>; Tue, 21 Apr 2026 02:46:09 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1776764768; cv=none;
        d=google.com; s=arc-20240605;
        b=UFbGXoBYRoAATKP5y+fUpXu78MRiY7+8s03N0mv3SVY7zjmzmNptFMHPMGkir6SN2u
         St2RTBIQfqlRvOqP2Lj9IDJInUBgBZJhLjagwnCm1HRSDdsCHGjVMuhIU9tOnDQ7gebT
         QQ6eFpdhfENY+GmDpTPS0qAZlDaBQA3MntzdSj6Glpsr8TOC7d7RCCcNgUVZD+EwHtQc
         t4JT0DfFW7o4uteMLcf3OarfgyL4YUA7Edo157u5Ydkf48FRyuYQy1c527vBmTY0kolo
         hrYUkX0Iz8rAOAHqunJ3npAzmj857B9/deUO6FkfYzcDQH/ZVygLv0cyOdk1+odCrDzV
         V1oA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=kcDf9Uq4J7samVRSXfkiUIHDySbB8vtyfJm5UY5edZQ=;
        fh=mdp6xqxgkDVvvTzrzOcYWSpa2I4pAra3i9SeReeijc8=;
        b=fmqIqZFjVNFmdn46lU0xnrcYVxhbD88whYqYW+oSmVvfmVbTGZWTjogKFGMFrIlSJ7
         5+7LhsTmNF117wPCFYvdEHBZdGodPcuB0ZS/xInXavOJ+ogCaG/WO2e0QuSckz7/baWH
         695bzih8BKz2W+wzbfDvoSfRoZ63Y42I6dJz3jiKybz9FtJ1jOECLrfX74bDo7g3srP4
         QLAe3aCjY/P/CWtEv/rqAHrbvpcOq7H7KSj/J+84+4v8XcUUkWeKXqRLObeS0povLd8D
         kL5A5k6G/gYPhrM7gBt6ENmVSlgoZabm2dO5FnmkwaljJF71+oREK1qgJLphywdhprY6
         96RQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1776764768; x=1777369568; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=kcDf9Uq4J7samVRSXfkiUIHDySbB8vtyfJm5UY5edZQ=;
        b=hsiqrTdEAxweHdyE4mjSxvmgPcA209c9YvJykBUMtL6fXCbbIiIqWg6JQTDnndFLCI
         ylCi3ibCPzbyr41K9uVuSXvO3TDzHMl1z5rbqXJMi2OnYBhHGJxatuRf1+SoqM9+GEs3
         PwRqBR2ipCCZfK+++iuYHgiliEBB57tbIVq8/BLdqEA5NMFzsEXf04r6cPA4atUwHeNt
         YVpwYGPomTqUVopNNRHY8FKsTek81G7iHqvcSi4BV+PfLoEH6NQnFE9pyf5BvoKJClf8
         7W5Rs+5v4HsAfof3xd2/T87eXDuI6Q0C3U7gNK5ZhbJXj2d5P4EAiWUZDsBAwp17eAE4
         VM8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776764768; x=1777369568;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=kcDf9Uq4J7samVRSXfkiUIHDySbB8vtyfJm5UY5edZQ=;
        b=XlEo8HUqa06Pq+eN9801Fi6VZTGAZrH1v6V3tRM+stKQ80Zh47kL90TpE/1IjZ3YBi
         eycI56vSdH1yO26j3npR4uox6ot0q3yAzH1XcN7wR6iiEZ8gXI/MyndYl+u5xg/0i+LI
         AvfXEfYZ1ZqzZjCuE2i5GAhFtmX4jxWovYpZoxlIaI0pIn1FCHR2D7y+q27Yprx2OO8E
         trkxgK5t3J7etOugVXYQGpbjkRjs54hCfGjfWE2riZN1voNgv4koAZa4yE4xIZtD87du
         61L3U41WO/7qJ2ppEp/5yx+TlAY4/uuDwk2kD6LyA3Vl0dbuHmGmvKgFPKJk0sKNC0MH
         3Rqg==
X-Forwarded-Encrypted: i=1; AFNElJ/em6EsEqPMNOjWdgl2EoqSH8jB7J/JiCTJnc5W1A+btLqoUTxl2p7/RJ9K8P9S27LA7yLMqoQa338hGERz@vger.kernel.org
X-Gm-Message-State: AOJu0YxDOjluxjZxvlc+MFWXM+39ILm2m8G5eaoPo3E9X8FSMZNnQgio
	tPqf+jJt7BRNoKCr7i8i4GePW1zhQd6Gx/lEOS+5G/v43cwo5g8I8I5hq5BrlH/esDEUlntVNvk
	niEGkyEN+VI8dKhuS9WwORj4oDQ7hJYw=
X-Gm-Gg: AeBDietxyp6mMsclY+7lc7skezVdttg1iG4HSBH6xI+6baVTZsmBovedspnZqZDVbtW
	CKWIRYq+23/OMNH30GbFXHaZjiPkWAT+1yrRlzS1/JrtcaWguJgGudQ9Gtpru0Pwa+R4GVPk3KF
	XLZmYLB/EOIZJIAqX1TBQpozOthgzvOofAS+hTvw1yYgXzIXhl1zTAdrr+FCbcqRg8p2FDDDFVk
	4k4Lkn2R4Wj07eJQWYrIsG/9GLFz77xzjvkq5KQS+v358urkhrwHRAonIgGb2+H4HpVtwgdkwB1
	xEBOBaQIduREYYJ/qQDanDsmrRtLFw2g5QopHQK+pIRKA7BcQyWyEXPD2aLJ1qE=
X-Received: by 2002:a17:907:3c8a:b0:ba8:2ebd:dfb6 with SMTP id
 a640c23a62f3a-ba82ebde295mr347876566b.23.1776764767533; Tue, 21 Apr 2026
 02:46:07 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260421092349.148002-1-sunliming@linux.dev>
In-Reply-To: <20260421092349.148002-1-sunliming@linux.dev>
From: Amir Goldstein <amir73il@gmail.com>
Date: Tue, 21 Apr 2026 11:45:56 +0200
X-Gm-Features: AQROBzCUUgt_denQzi9xXeQRG2Pgax1LQtiTZ7pxr_LNcQbDYchqD_XRKg7Vpcs
Message-ID: <CAOQ4uxg8TdvtqE69cmizFh1OV-EBJYcJ9PMxDkYFXEPWZd_=JQ@mail.gmail.com>
Subject: Re: [PATCH] ovl: Fix possible NULL pointer dereference in ovl_destroy_inode
To: sunliming@linux.dev
Cc: miklos@szeredi.hu, linux-unionfs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, sunliming <sunliming@kylinos.cn>, 
	linux-fsdevel <linux-fsdevel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Apr 21, 2026 at 11:24=E2=80=AFAM <sunliming@linux.dev> wrote:
>
> From: sunliming <sunliming@kylinos.cn>
>
> In the ovl_destroy_inode function, a variable reference oi->lowerdata_red=
irect
> that might be NULL is directly freed. Add a non-null check, and only free
> the space when it is not NULL.

Sunliming,

This is nonsense.
kfree() is not a dereference and kfree(NULL) is allowed.

Please be more considerate of my time and the time of other
volunteer maintainers and do not post patches that you do not
understand yourself.

Thanks,
Amir.

>
> Signed-off-by: sunliming <sunliming@kylinos.cn>
> ---
>  fs/overlayfs/super.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/fs/overlayfs/super.c b/fs/overlayfs/super.c
> index 60f0b7ceef0a..4b8b5fd4ab59 100644
> --- a/fs/overlayfs/super.c
> +++ b/fs/overlayfs/super.c
> @@ -218,7 +218,7 @@ static void ovl_destroy_inode(struct inode *inode)
>         ovl_stack_put(ovl_lowerstack(oi->oe), ovl_numlower(oi->oe));
>         if (S_ISDIR(inode->i_mode))
>                 ovl_dir_cache_free(inode);
> -       else
> +       else if (oi->lowerdata_redirect)
>                 kfree(oi->lowerdata_redirect);
>  }
>
> --
> 2.25.1
>
