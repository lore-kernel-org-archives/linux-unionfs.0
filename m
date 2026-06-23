Received: from mail-wr1-f52.google.com (mail-wr1-f52.google.com [209.85.221.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 641A43890EF
	for <linux-unionfs@vger.kernel.org>; Tue, 23 Jun 2026 17:12:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.221.52
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782234755; cv=pass; b=PBwT8+GvbYgKAu2yryZNq2x727NoSwWTKvIbwo4Npc4mk8b9loDpXydpTXpYBgcGGmmtc6ew8v/rNYU7A4d6dZ6TuKd3CzNdZMHZXj68GBdrUo3B+rZAj6/9diKfdOgkmReG4lUrjSGSF2+4hyca72417hKT6KyUlVn9Ld1uKuY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782234755; c=relaxed/simple;
	bh=hmR9D8Br+YBjZG2zebbyzPQBf1lj2xBVoaEGicS5Dc4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ZQ1M8Mta9BZj/CanFNmeEYKXLtZT11OvOdi6wByjyqSAHUFvz4MnTvToI/pnMr2+v0qjJXVjjXasrI2I5LWGubxbCpoxMa8WymRd/9hwE9e7ycXJegKMbnlKWl24u+kAws2U6o73dDULMADN02af9jHom/xvBiyatypEetoq7cM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ZIInnUlR; arc=pass smtp.client-ip=209.85.221.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ZIInnUlR"
Received: by mail-wr1-f52.google.com with SMTP id ffacd0b85a97d-4629d80fa08so121229f8f.3
        for <linux-unionfs@vger.kernel.org>; Tue, 23 Jun 2026 10:12:34 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1782234753; cv=none;
        d=google.com; s=arc-20240605;
        b=Hi/pl9H3CrfIiP5Gu1kFuVjGmPUActtGrkd/qMYwv2KUYOPO6N5gx9Y9sfZ/XwAxkO
         kfxuddrQHWaV2nRSL/cwSAjH/wqdTz7EjqaMqfAtsusvYMh6HN/X2CmkX/pFjX0d9Exe
         Z92uQY0Xgb8zyY+SnW+xGzWnbcuWON7Y9W+CPmQWpXYvEwpTswQkqX/P5cEeKHMxLNW1
         VAl+HAohyCymb6iP0x1JjzYiMUcD2ayR/GzhBM6WvAL2SNNUnaDIQCi1iKlXdVbeWb5f
         5lV6sxWccJeZHsF4au7AobM8LdvmTCWNlnsr2l3Z9FPL2L+8Pfp3QeGst+UYca8t99+N
         LeSA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=GQis8KO7+Cr37wQe2wy0qBtYljKSNFAIw/U+lZxu9Bk=;
        fh=IAjOlXs1h/dWXZ4XBmK7ZA8DXt3rz7lRPGFQjCJ4T4g=;
        b=KKy2cAU1AI3YsOkZqog4k5vudDPyJugWG+Qb6OvSQyVbw+WTYCqNUeMImawMElPH47
         N1z9ryshlRW17gtDtxtno6OkE/lfCzdQLs8Dq96lUZaUB8tDFJEtomKG1JOdUxYLiky0
         WIeny0yMDnVQzhD37kyCgJlMDFkOo91A6JZB/WMXl6TuiYAFPUknTWHWU4uE8OqD9cQk
         xaZ8elTcfgvarKYS2hMj7gVftTI6zY+8iB8kMRBMAd/U8SgXxKOQnaKV6/Cjp8cGgGuO
         dw623JojgyQ2i0YTj6jFSvQsvMlok5qDrYByncqPBSIkchC6ZdWIWCTIYWSfelUEiTGf
         EkLw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782234753; x=1782839553; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=GQis8KO7+Cr37wQe2wy0qBtYljKSNFAIw/U+lZxu9Bk=;
        b=ZIInnUlRpJBrBLa4YHmK1T/YeHww3CriuYJ+s05YmBTe9hKCb9ZRskiq3iOgtmPzFd
         BO5+sawX5DP/dYIkp48lyGPGLZuMlU2B5ExSz6tAaPXbflRW58jxxcbYBY3wy3+6VUHy
         BuAv1K2BT2xt+XlBgLMoXmDB+Us7uSmvTTxbrDRRhv5nnWvjCsyd7yvFRxohrkF6M/PU
         KImC9eeyFb9l/9wbKy3v/jFfZV5c0b6MFsfYsy5jWI5o1kvtNzCAVMMBR2X7c28sWRoh
         KkRWX0jEeHOEQo/qs3fbGUlQTtm0uuWVbu/2igo1pXV7K+rMeUPCowk4apnjv5mQ8zxO
         ocmg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782234753; x=1782839553;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=GQis8KO7+Cr37wQe2wy0qBtYljKSNFAIw/U+lZxu9Bk=;
        b=MOMVJttURXxY1SS9D45Z0ZsAcygnzi2u1cutXJxlcFRbdIW0gLzqBQaaeRgIKi5+he
         x1ql8Fp0QwUT1FiQvgcOfgigLUZRPtCD+O5grlTRwesiXo/m9UWcjXlSfVenpeImkupb
         oESsAaLH+MSvL3zCCNdDjbGhYvKJ4Riq9MvI7JqTDPR6z/yVQ8byXvWgxSxhP+hTlEMP
         Dmb7xHyBXhzQlTHpANWI3qO7ore6s0wXOsa5IXM2cu4WbvqEcGukhyT43DdHMCqvC19K
         hMrSSyjogCaV2U9Y72T9UoWM8duiWD7wB8lcWw6LcbZBxZV4hpMEpBjObFNHR9umbVGF
         ef7w==
X-Forwarded-Encrypted: i=1; AHgh+Ro1nmSgjlGCC3fDhBWalxFm/5enBSZlKpRbqLYnG4N5njTMZKyIOVb2uVyaELoler/id+TELYWYApF7cwiv@vger.kernel.org
X-Gm-Message-State: AOJu0Yy7HoLSmfRgt89qFQAY8dWKLnDap4erdjl13OcKAgzGT8V3E7CA
	ERG4F1SAP42ptzUtPu7xCdmiKAxrWIFaqKwXR9tdsNKN87ja4lQxBD4Hb7t2oKShLyRnZIWuWCn
	bUqIOMA14gSsX+Um8hxsnmva3qM8AAE4=
X-Gm-Gg: AfdE7cmg7x+fH66YDARjXcnV5tPsGHeUZVMtD+qCucouvfgF0DmtDjbTKjfRo810JMe
	umW60uQKjGeAWKJd48rRvmibep3eogDvmwsQjvDsAdEtiY5RwBcbbiGfWHguhvGo6K3ufe6aTjS
	crQv/2Ej2d/Bi2B7CvnTXkcgaH5ywXm5IHudMvXWkbVK0diJC843HAqh1jirxQp3n3kmBrR+aM5
	zGN5kq2hPGbSnMAX2IGZ928aMSBeOtmXkI2wy+oKQIgh1+oB32PES7BF44y0iw2IYoDdcWq+R9Y
	AQFeIFbLBZ0lFnycvbSbcO6F+ndaLCYcqOOjRUM=
X-Received: by 2002:adf:f182:0:b0:460:6b0e:a75e with SMTP id
 ffacd0b85a97d-46506c35d0cmr25528866f8f.16.1782234752678; Tue, 23 Jun 2026
 10:12:32 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260623111533.2285005-1-ptikhomirov@virtuozzo.com> <20260623111533.2285005-3-ptikhomirov@virtuozzo.com>
In-Reply-To: <20260623111533.2285005-3-ptikhomirov@virtuozzo.com>
From: Nhat Pham <nphamcs@gmail.com>
Date: Tue, 23 Jun 2026 10:12:20 -0700
X-Gm-Features: AVVi8CdfcxG5r5FMFto7l_ai_RfkpnO9NQCVALwgDokVA4D7LTvynw9skPuPn8c
Message-ID: <CAKEwX=OaKTfNqzwa=djLxZDeBbR1+DKdqDnxdfPfZFKB-K+ECA@mail.gmail.com>
Subject: Re: [PATCH 2/3] ovl: support cachestat() syscall on overlayfs files
To: Pavel Tikhomirov <ptikhomirov@virtuozzo.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, Amir Goldstein <amir73il@gmail.com>, 
	Alexander Viro <viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, 
	"Matthew Wilcox (Oracle)" <willy@infradead.org>, Andrew Morton <akpm@linux-foundation.org>, 
	Johannes Weiner <hannes@cmpxchg.org>, Shuah Khan <shuah@kernel.org>, linux-unionfs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	linux-mm@kvack.org, linux-kselftest@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Jun 23, 2026 at 4:15=E2=80=AFAM Pavel Tikhomirov
<ptikhomirov@virtuozzo.com> wrote:
>
> Overlayfs forwards data I/O to the real (upper/lower) file, so the page
> cache lives in the real inode's mapping and cachestat() on an overlay
> fd returned all zeroes.
>
> Implement the ->cachestat() file operation by forwarding to the real
> file via vfs_cachestat(), the same way ovl_fadvise() forwards
> for fadvise.
>
> Signed-off-by: Pavel Tikhomirov <ptikhomirov@virtuozzo.com>
> ---
>  fs/overlayfs/file.c | 18 ++++++++++++++++++
>  1 file changed, 18 insertions(+)
>
> diff --git a/fs/overlayfs/file.c b/fs/overlayfs/file.c
> index 27cc07738f33b..a7e252a91ea43 100644
> --- a/fs/overlayfs/file.c
> +++ b/fs/overlayfs/file.c
> @@ -518,6 +518,21 @@ static int ovl_fadvise(struct file *file, loff_t off=
set, loff_t len, int advice)
>                 return vfs_fadvise(realfile, offset, len, advice);
>  }
>
> +#ifdef CONFIG_CACHESTAT_SYSCALL
> +static int ovl_cachestat(struct file *file, struct cachestat_range *csr,
> +                        struct cachestat *cs)
> +{
> +       struct file *realfile;
> +
> +       realfile =3D ovl_real_file(file);
> +       if (IS_ERR(realfile))
> +               return PTR_ERR(realfile);

We're propagating the error of ovl_real_file() all the way to
userspace right? I think we need to handle this.

For example, we might get -EIO here, which is unexpected and
undocumented from cachestat's POV.

Maybe handle it and just return -EBADF or sth like that (with some
updated documentations, etc.)

The rest LGTM, but I'll let overlayfs maintainers check the
overlayfs-specific bits :)

> +
> +       with_ovl_creds(file_inode(file)->i_sb)
> +               return vfs_cachestat(realfile, csr, cs);
> +}
