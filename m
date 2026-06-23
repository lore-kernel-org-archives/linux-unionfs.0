Received: from mail-wm1-f41.google.com (mail-wm1-f41.google.com [209.85.128.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92BE0305968
	for <linux-unionfs@vger.kernel.org>; Tue, 23 Jun 2026 16:01:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.128.41
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782230483; cv=pass; b=Z9oK+51T5yA8DuU+kOwM1/ldzgTY7fOfAtDzvKm9SkSDc6SezQRSXbFz1gHfuRLZieHwjHgisg68Bqky6MFpkuhkRXKoApX5yBEd+bLRwcmpBgdcN15Bu/WnBC2c/DkAHSfouAulrxOrzwctYiVGy5SCB8HVebSEgOLWCq5J2eY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782230483; c=relaxed/simple;
	bh=moYzU94ucfDv9Ns4t0FmkzpOqQLV5Y4B3n5z4+leBVY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=KvBeBB+8O8P7egSUJOtzj0S/bNGjDFWGTANYwm+nSVXIMFpF2A4ZCL0A0U8+txRhX9L+9ahzOHck2dkVeo4SCtDxtLLOfZvsJAwyQjFE4c42PIMB3vDQW3+LQLcxgnKRoiaP8q03sW5GG/My6XEhwJfsTxT9i99RgPw8gXpLXUM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=mDUT+SxN; arc=pass smtp.client-ip=209.85.128.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="mDUT+SxN"
Received: by mail-wm1-f41.google.com with SMTP id 5b1f17b1804b1-490b8ac62baso11968965e9.0
        for <linux-unionfs@vger.kernel.org>; Tue, 23 Jun 2026 09:01:22 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1782230481; cv=none;
        d=google.com; s=arc-20260327;
        b=B9RD8V3PZ5xjROuuvLFNk6DRsayRM916olCWYehtwYgJM32ZYUi9DXWbUhJgBN/szc
         wblq7IY36zg2+cjazyuPdQD4qYtxh4ProfdTMjjSSInHnADL+Ovh5zGUDZiAVrEH4n5H
         /937jXgDrlNEG93ou7rzll/s+1tilITnNzQGA44mbFmxUqCAiVa/msnihxTW9NQpCHZa
         toZYUR9OwlaxWJivGmKfjQYVwyv2raIK2cOB3or0CkJdARUSI4UsS3aAnm0TtE3zkJTT
         aG6VyCY9DEaZv0kHmDWewBS8Ufbb96ZFTrf9RWlnjjVgdCgeZ28jZZspad9mwdXThNAH
         3Lzg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=s/dOweBfHSKsBXHjB0p74I+BF7H4VxwvcYuFUhDSwpQ=;
        fh=5FSmoWjAiyVcb7bXoLbwnLsAX5eQhsYYwMuDTVTUPRM=;
        b=StsNpsFt0FcCvuFXIQuePQKCY960D4thxaY77Vdueqd2PRfjjCQVBUtsS1lZ3LmJGQ
         C9NiVwXZR3nj2VX1Ruxt56D9yKf3OS+i3S4IGj4DcwcUgXMt1rDTxBMj1GzinnGHXL9O
         CVQNOz9ydEyKfvJz/j2RXj2VsPn1HU53ahBwJV8r0S+reC38Kk3se9LSUoJvIG/LlEk1
         sbmg6PWH4jmlZmkXkMft9KXaXirnTLVzbZwNTowA6jSvC2Ejr/t5ShGElm2aMbCePAEN
         6ThllPVCdBQWnjz3pu3AGy9pDj3VCa9H0tro9j3ynF3OQLa0oZVC60K1sTfcWsDqICXq
         aJyg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782230481; x=1782835281; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=s/dOweBfHSKsBXHjB0p74I+BF7H4VxwvcYuFUhDSwpQ=;
        b=mDUT+SxNtY8wPw8JLRXJdWRSX3bGO2cboOMb/HtZxGz3piNl6QUNZDmEq5Y99jnUpJ
         rv9xv9ZKXKEEGgZjC6o0hqzWTGvm8MVMBp/V1VJsIaK6eg9L1cZ5Vo7lzYN5HeTZXkrm
         VbY/NDZBbbRpGxBiM/UpljhJoJl8lCCO2qyLubFT4PBhnyocQDe9jSRYT9uVTC5mB9K3
         fxEUdiag2v3CifSUchmzAtlSKv1I0zT5z8z2ybzF8rEvyrI5JOt7LtoTweWEgqnl1lMx
         +8bD17Rf/77AKta+qv5Tp+BA+SQeiGQ1H5wXP1R/DaSPbU+x/GJxs3duhzyKBXGWJMbE
         NZMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782230481; x=1782835281;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=s/dOweBfHSKsBXHjB0p74I+BF7H4VxwvcYuFUhDSwpQ=;
        b=JWhbxdjzTK+9u17Seyx2sb6xZ7XQMDZL1I6OzdFqwTSJsrWuBdwT2nCFWLBaPl+c5t
         TYgfJlBxjB69vmpfm2roysCv5eJ0cjkJeqiPXUQvxRGndSmy1dCHq4+L/qHiXqjGyaYM
         2LIV9+jrss+kZWnRhcfUV58SWUizBVdDSy5XLFLKacMRJfQtcVIn61M/uG47X0JeUwhZ
         tg0/4FfgGVjPzoVvRGO/hzpGQTOf1iB0LXQYwQI1jhfMhFtiYpQmJlce7AUzMWYBlgJ9
         gO34xaU9J5bOsge9edqZdL0SNPzXJIaCyaqg3Y1nQxcN6Npa0hWsaHwqxt5UT4DLrSnK
         RbGQ==
X-Forwarded-Encrypted: i=1; AFNElJ/6+zhmvYMYhScYnWelBXI0D+i6V2uapF7LQvygJcVWGdjTCM5jsiq/BH9UUwHESdXeFBfKhs8d7DMczSuu@vger.kernel.org
X-Gm-Message-State: AOJu0Yw/1RNaroMp+WEQgWVdtsGmx3MiNYgcbGuKhI4eBBa//X0tVqXP
	BCGo1G1pjS3a2nA4qfCQiWISuunyuCUHbaVb8jo5I6mzA1lSg8liWDbdcvw5RPjMLPOP4my9y8u
	xE2bcwdY9J+qRFADMzhNIU33xW0swZ6w=
X-Gm-Gg: AfdE7clSR5SJHQgueuZx9ohQV9nD4PsCTQCFXNxq29r1XJuhkqiFB8W9Xr9lZWJIakr
	Dc9Yx3Pc3nCE6M/Qco1UOnO2TmqMaipYXRwFMWpiHSrt9jXD/jCoeGdUxxBmln9OWAaEdSQHIAs
	grKFXxf7u1/ycA2lypDs385BN6M1hU2+kD7Xr5TLSp1GHLIbXSt4yt+HOW5vBtSgEcKmpyVe/sj
	cMPDahNEhPe4ABHarkcAzTXOnMYAGVvbxPZTdQyQ/V5whPqWgd5xqAzG52nwA0hiEJ5hHJ6ZUQK
	9kVX9cW0EGukFpkZFz2eVdY4jAtW
X-Received: by 2002:a05:600c:c099:b0:48a:5f32:62c6 with SMTP id
 5b1f17b1804b1-4925a0ea8b4mr54371835e9.11.1782230480787; Tue, 23 Jun 2026
 09:01:20 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260623111533.2285005-1-ptikhomirov@virtuozzo.com> <20260623111533.2285005-2-ptikhomirov@virtuozzo.com>
In-Reply-To: <20260623111533.2285005-2-ptikhomirov@virtuozzo.com>
From: Nhat Pham <nphamcs@gmail.com>
Date: Tue, 23 Jun 2026 09:01:09 -0700
X-Gm-Features: AVVi8CexJwF1YIejddCZO0Cw6M7tITGeNOUnTTqz8Z9zx_6aZedVwaVA3e5pkZk
Message-ID: <CAKEwX=Omr29YZ+ZtDXtVLKQVoinGo3y9xWBJojRCBpewgswycg@mail.gmail.com>
Subject: Re: [PATCH 1/3] fs, mm: add ->cachestat() file operation
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
> The cachestat() syscall reads page cache statistics straight from the
> file's f_mapping. Stackable filesystems such as overlayfs keep the data
> pages in an underlying inode's mapping rather than in the overlay
> inode's, so cachestat() reports all zeroes for them.
>
> Add a ->cachestat() file operation and route the syscall through a new
> vfs_cachestat() helper that calls it when present, falling back to
> file's f_mapping otherwise. This lets stackable filesystems forward the
> query to the file that actually owns the page cache. No behaviour change
> for regular files.
>
> Signed-off-by: Pavel Tikhomirov <ptikhomirov@virtuozzo.com>
> ---
> Note: Memset change might be a bit tricky, I moved it to no
> ->cachestat() path to avoid multiple memset on nested overlayfs, that
> means that ->cachestat() is expected to be able to handle unitialized
> cs.

nit: maybe a comment somewhere to document this?

> ---
>  include/linux/fs.h | 10 ++++++++++
>  mm/filemap.c       | 43 +++++++++++++++++++++++++++++++++++--------
>  2 files changed, 45 insertions(+), 8 deletions(-)
>

LGTM otherwise. With Amir's suggestions incorporated:

Acked-by: Nhat Pham <nphamcs@gmail.com>
