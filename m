Received: from mail-qt1-f180.google.com (mail-qt1-f180.google.com [209.85.160.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9A0E33710E
	for <linux-unionfs@vger.kernel.org>; Tue, 27 Jan 2026 11:20:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.160.180
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769512807; cv=pass; b=OCYGuM7YvSPCqXadiK24jIzOTyXkrJFAMsp1bLlJ3T8hMNgQY13e5tK/CLJjiJw2nQduSphmyAnRMVqjtG8zJYUDqVKL2t6uEJvjJK3R/5NgLOuhKxgkGvdH1z6J0enSl1sWsXnlJNbjHWy/VA/7S6R9EiynYKRv4tB5OZKYiLo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769512807; c=relaxed/simple;
	bh=+V/rhp3YwutTk+iojauQtW95jZiNcdkRAoPRrbfaGNM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Q5CUnmWvyArfto10mIA42KkQNhuhPc8081eh5bZ7iD5/wsqZM9WwIRApgrsD8dTVL0DBOEu3t2+HqSYRUblzZ9E7pT91ELPZ+hyOKJU8o06zbTlL/MdV17aODnYxijF4+EO+db4Fk0dNwEciQOC9Tsx3MWOAXbkVY54/gv0EfQk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=szeredi.hu; spf=pass smtp.mailfrom=szeredi.hu; dkim=pass (1024-bit key) header.d=szeredi.hu header.i=@szeredi.hu header.b=KfkMZ8N5; arc=pass smtp.client-ip=209.85.160.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=szeredi.hu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=szeredi.hu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=szeredi.hu header.i=@szeredi.hu header.b="KfkMZ8N5"
Received: by mail-qt1-f180.google.com with SMTP id d75a77b69052e-502b698e510so68311691cf.0
        for <linux-unionfs@vger.kernel.org>; Tue, 27 Jan 2026 03:20:05 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1769512805; cv=none;
        d=google.com; s=arc-20240605;
        b=Geuz5b7MB2W/Nuo7w5voffXd7ECseg/eG28n3etfzzoVoEmi6uLCQkcvwAdyWi9fsh
         w4aojD2rqyKwu/Vup2lz7jsYwh5uAh//FrbomAwmCQIMmDrBCjcbdfiaJlL/rD03lEis
         xxlsLleR+EscFiZeJx4VUmD53IJ5Rn2PR+/AFFgn3NQ+ZNXEaPd/Y3Ze/9IY1hPp1PI2
         NMMdGOwPf/tzoxWZlz8mwAjipmN14Bx7SNyCB+hSYss3Ef0HPH3X/RVWubevE3DDHUPB
         ir0N+1d5JoAn1p9wDhokOGq0MzpImzd7FlE7CnEapOmUEsZrkJ9t/2z1Y71lHDZzQPYX
         oC4w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=IFikDpAF8sr06zjv49MDbJL8l/pB7KwG8LV99Kz9suQ=;
        fh=9dST1Cn9BzGm8rdIgk2OC2Boo9BROXEOlSGQc73g3do=;
        b=gcnMeJDAfsfFDIsGnZjbafykrTQeyw6o5kWpu7W5y+JIsm2jmfARtQDkUl0lyEkg3o
         0wudM2pwY82wo+st1koXAcxPZZ0CIl5j8RItxAzfUGQvXs+5HNSRjOKetUFdTOoWq9pb
         zI3cKE67sd6WAZS98RwZp3Qnkuho1iwmPPlIV//LLaWvayn06xQJsBjgLBr2mG85mO6U
         XuTC5IgGDt7XvFUEPyHXSDX441ZVyBvhWQgYR0vAlX7hqXuL3NZIse8PKHNIo7md8M6Y
         uhjB0oVuISAlHctoJVeEPqaJL+KkIXkIo9CZz5u4mJSxFc9BEn50U0ro/RnyGGU/n5fW
         LiYg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=szeredi.hu; s=google; t=1769512805; x=1770117605; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=IFikDpAF8sr06zjv49MDbJL8l/pB7KwG8LV99Kz9suQ=;
        b=KfkMZ8N536QPvl2iFbnEk/L1P4YQhUIx2w6K2k16jVodRk6XBSLM0G7GswneP2IfPZ
         2QWB/UKNxTvEkEZxbULp5njNy4MkiBfdYm33kAluQulsvsRpORBozsGfc1ZYiea9YBsf
         c1AJgbEIywydYIyHm+oPHGni3l06Ul7T9yZaQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769512805; x=1770117605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=IFikDpAF8sr06zjv49MDbJL8l/pB7KwG8LV99Kz9suQ=;
        b=QULY8+OhHOKa7C538hv7+HSmRg7lCJG2YLlaMyatk4VS5DYoZIkvsgXDVW+34AULQF
         LZulBMkjgeKYUk2Yqu192Q57zUSLhthBIHFTBiJxcsiHcLF5GgasHZ/aoY8IDA/MaFvI
         lFatV3qSPVP23VlOq4RHBaw1bekiMUDSaXSyD7L4kKBvEEn42e9G/fnMM2Y9Xo+S1DKW
         RYTSrxSpiAeMl363pvy5xfbEVykxioC05/ysKjjrXpM/+VxrkC7UnGBQt40mykIMaQ+L
         LUpmNsuMOm7PmtqGDlKxY91bWmODFwWcrcuAqxVnyW5gGWSTBDvmzgVUiOXzPS5cWRVh
         n+tg==
X-Forwarded-Encrypted: i=1; AJvYcCX+3NiAcXpBQvZVcP2TEKNwz8klKi/IkYhQIOLILI+OycH6FZ7VTmJJ99fZ//otfusTslT+QJoAJCANusJW@vger.kernel.org
X-Gm-Message-State: AOJu0Yz2T0017hJqKdp1tB+CabYtprU176f3eJUtMddsbGwNOSY87jbr
	N8f/E7NeUdwAtPIWPWg63t3kPy3SdJxgQS8meHVPED6KNmLMPvUwYitPEd840G9Zk7MoH9WLULs
	C5In2kBIJwa5PRLShFZiFdeZPIklzH67je990poj9Iw==
X-Gm-Gg: AZuq6aJjOJCzfZnnxT7X0YRMM9x3aGV/0ps4je5BgfIYCMU1q2FhSK3h/1RUbxxgmFR
	NwMloqOAP+XrnIMFF3ZSRISUjgdLmMtH/guVDBDR9la7ssSE80udoi7ukjqsLZujx0XmxAz4Vqp
	7hhWNonINHhgcGVgUEgpD9PReUKJtUcoYGT0w32TYRzbeFqeY6A65rC12sBwuTHxSio97cGAPHx
	PgPF7lWGOHKEZQe4OAysrHMbGbRKMx0xPTMlG+CLzSx18t+N0Vj9kInZ0nn1SrYfJMEDSN18FlV
	/MjDvw==
X-Received: by 2002:a05:622a:394:b0:4ed:ddd9:1402 with SMTP id
 d75a77b69052e-5032f774849mr14226971cf.24.1769512804740; Tue, 27 Jan 2026
 03:20:04 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CAJfpegt_n85jDSe9k9GcC_9KB=+R_oUeJTPt+3XSPkhjBPm3NQ@mail.gmail.com>
 <20260127105248.1485922-1-wangqing7171@gmail.com>
In-Reply-To: <20260127105248.1485922-1-wangqing7171@gmail.com>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Tue, 27 Jan 2026 12:19:53 +0100
X-Gm-Features: AZwV_Qiq64IyZx3bQolAm4yhzwD9Tj-etshDijyw4Af_x15Mcc57aJxAfeG73Bc
Message-ID: <CAJfpegt9yLioW1dEmGYOfib=TcuWVom=Z+a+bN+jS_8wFie90Q@mail.gmail.com>
Subject: Re: [PATCH v2] ovl: Fix uninit-value in ovl_fill_real
To: Qing Wang <wangqing7171@gmail.com>
Cc: amir73il@gmail.com, linux-kernel@vger.kernel.org, 
	linux-unionfs@vger.kernel.org, 
	syzbot+d130f98b2c265fae5297@syzkaller.appspotmail.com
Content-Type: text/plain; charset="UTF-8"

On Tue, 27 Jan 2026 at 11:52, Qing Wang <wangqing7171@gmail.com> wrote:
>
> Syzbot reported a KMSAN uninit-value issue in ovl_fill_real.
>
> This iusse's call chain is:
> __do_sys_getdents64()
>     -> iterate_dir()
>         ...
>             -> ext4_readdir()
>                 -> fscrypt_fname_alloc_buffer() // alloc
>                 -> fscrypt_fname_disk_to_usr // write without tail '\0'
>                 -> dir_emit()
>                     -> ovl_fill_real() // read by strcmp()
>
> The string is used to store the decrypted directory entry name for an
> encrypted inode. As shown in the call chain, fscrypt_fname_disk_to_usr()
> write it wthout null-terminate. However, ovl_fill_real() uses strcmp() to
> compare the name against "..", which assumes a null-terminated string and
> may trigger a KMSAN uninit-value warning when the buffer tail contains
> uninit data.
>
> Reported-by: syzbot+d130f98b2c265fae5297@syzkaller.appspotmail.com
> Closes: https://syzkaller.appspot.com/bug?extid=d130f98b2c265fae5297
> Fixes: 4edb83bb1041 ("ovl: constant d_ino for non-merge dirs")
> Signed-off-by: Qing Wang <wangqing7171@gmail.com>
> ---
>  fs/overlayfs/readdir.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/fs/overlayfs/readdir.c b/fs/overlayfs/readdir.c
> index 160960bb0ad0..9ea3cd11dd93 100644
> --- a/fs/overlayfs/readdir.c
> +++ b/fs/overlayfs/readdir.c
> @@ -755,7 +755,7 @@ static bool ovl_fill_real(struct dir_context *ctx, const char *name,
>         struct dir_context *orig_ctx = rdt->orig_ctx;
>         bool res;
>
> -       if (rdt->parent_ino && strcmp(name, "..") == 0) {
> +       if (rdt->parent_ino && namelen == 2 && !strncmp(name, "..", namelen)) {

Yeah, and also the str... functions only make sense on null terminated
strings, so that needs to be memcmp.

Thanks,
Miklos
