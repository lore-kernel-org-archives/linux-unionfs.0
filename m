Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.128.51
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794859646;
	b=nGICj4MfBV4N+Ve7UmtRr9RDIR21YRhELu/rb86w0j0gCtz/EX2bJfbOnd+vJHjWwLGj
	 8kNYX8Kysqeb57cLNwOVTdTCapkQY+j5XN//CYN6Y6Sbf5e0PHWY47hLmzVeidOXiEGjX
	 oRac0DGMvoRwteUqStIQTHPeb6bs35UA0hTN8ok+nHNmsISnM+jjCPY5IU/xTUj6c8cEQ
	 BruqB/3xSvgfILOMFpZytovsMZ/KFH8BKyK3tsv1y2Wuw3DJ9OPWPvptKPkEbGSl/hZ0u
	 YHi9HiKJxvbYDXbOuKJ6QW9zuU3BteKjn6WA77xfHhfbrEOLEe2rdjjkm6E229516AA==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794859646;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=EZDAQV8yhgMyPQgwR3U/5djFDS4+SZxlS+9+Esw/bYc=;
	b=j6F2FG4hXS+hntCkA9XCvhLE7QChmeIAGsIz+DK/kn5O/3Z6r3uefzNsWKfZ/axdv+Jk
	 ACUefMYpPPqiCzF58Nzf/8sLVXgKonct2a7lIWdYu6pQZ/GXQ0pEfnRnQkYLjcO3/AKqk
	 dRCTJR5korGethqy8HB6UIQnNCxLwrteOeHZmodswc0RXzCpYyamsAjnlBOOHnAcOzVFp
	 wFh5qL4hHQhLNGiJYXXP5q1860gDclB5wf2QmQm2P4VsJNTdERQK6lQRmr2UEOGvZT3Da
	 FuVWXeAQFtu+PwLwyMcj/wyZKLb/NUPpdQnmNdahE9vl7hV59m+zZz+vfv09meKWdOQ==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=XFDBy0c2;
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.128.51
Received: from mail-wm1-f51.google.com (mail-wm1-f51.google.com [209.85.128.51])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 292EB606A889
	for <linux-unionfs@vger.kernel.org>; Mon, 16 Nov 2026 20:07:25 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 292EB606A889
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=XFDBy0c2
Received: by mail-wm1-f51.google.com with SMTP id 5b1f17b1804b1-4b79502c27aso32098765e9.1
        for <linux-unionfs@vger.kernel.org>; Mon, 16 Nov 2026 12:07:25 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1794859644; cv=none;
        d=google.com; s=arc-20260327;
        b=Y1AUGKLGHpeStKv10c1M61snjn6b61M4AFEoaZwH7GmcG+lJs5ldmuayWL3NAB/1ut
         C2TUWPJStNzahMiapGonD+NlYoSSiGcGZKGcPAdUOncGOs/EUUHQ0kuLMcMiZoCrotpv
         8zGeia6ukihYMml1hGlT0dPu6N00Ingt1qC01/YBpxiqNVAG38qUumlI8qIteybZBX9x
         wkXiR9n3ddsi2ianQl2b5zTYaRw3T7J27OAIaass547tthaX1T7KFbPUpPISOqs10fs6
         oP3GvK4P3AG1YwzzGuHsihMuCd/VbEBOL+dFQxb8+V0Z7qrH9LI0lUIbXMc8r2/7xp2J
         EmLQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=EZDAQV8yhgMyPQgwR3U/5djFDS4+SZxlS+9+Esw/bYc=;
        fh=rA4+8FcdVuZ2zWEHIuM3O49KDSrsBYIWdBzTgylcJMU=;
        b=GH0jpvJ0XD5l+cp1a5oaa90ObWizU45GtnI2/gulVSuFIRFYTkkiERcoJv1gUBvor/
         /3MBInaKNnu+K+ZySv702+/nhhuNSK68/WVRM10PXXh0D5Z2mjOr7w6Gxvdsrtj892eb
         6Gkxl1vGFh0p8/N6kKfNRMrLGj3xebWbQTi371RrZMej28zZ72nKo3/2lV5lJOiNnRsH
         FS1iVNE7x2pUphd/40DKta00mfyyIJ6M/A9EmpFWtwBaxPzPfNDhn/hiVEB08GZamKkd
         KzsY31NxPe87LCHz54xVCIQ9bfkcTZrm/2cw27qPAXxKGxCutwfC79H1DTCnx6jE376E
         wkIA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794859644; x=1795464444; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=EZDAQV8yhgMyPQgwR3U/5djFDS4+SZxlS+9+Esw/bYc=;
        b=XFDBy0c2q6nTYiJ4dwLENH1mguXX/IcFF58gOeYQArjps79P1XpkrhGZpUclTyZwpS
         r/ZYwRoOG8WhRg+8JvLZN08T5FQLHs7jA/CzeQCQsJeulI93s02F+iYtli/pBjYHG+CR
         W2MoU0n/+grSPpLZW83MAsn9WQiLh5CCwtBf/0GxLqRHC416IFZ4i13TeIFhLxmbz0il
         NPxDzLDOL7N17VVYsTOL0jDLDvB5woBcjlvcU+oGB0Wrnz6q9rCc3VHuwmdjl71ac6+n
         fuvYHmykPJU4vuSvTSKMetyKY9BqLddb2of0qXOJ87q21uNxSrudqkhk+T/+cyqihyd7
         2YNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794859644; x=1795464444;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=EZDAQV8yhgMyPQgwR3U/5djFDS4+SZxlS+9+Esw/bYc=;
        b=JLgykGn01rSBLH14ulj7yjEZjgdZ44PS+/7z4HfL66viKl4dpjE1wRwW1Bm/xfkIT3
         MRe4myC2DAXLhe+J++KNVMrUM/Hw6u+W5m2tlTBDCJIkueK38921cZ22F7klH8A0Hxo6
         tXZwUbOddVT3Li34KbQQ/pZ0MnWGfR90olLGaqaolZuLB+GySpP1wWiYgP1FVAB840KA
         nC7fWVDLQBBoQkwEtZgT1mrKC7/m+nihmAbJ+CSm7Xgz+Wt0CbMiD5xrjdBpEkZy0nSr
         xu91mrq6AqW0gl0YAOzq3uALQO7cgnJCvIoFDnv36u4EkYVOa6u7D+DeQGmbnLcx8hHJ
         +1WA==
X-Forwarded-Encrypted: i=1; AL+hErH4+f/fZ8fRpOauqPq4Eo1Rw9nKbpFK5FDfqJMRIUPAiq1Yk0sODwpi2xLOyo2HXHBFMHJetNO6bS/Vq0KX@vger.kernel.org
X-Gm-Message-State: APuU4Z/PpHXZQhZOAFxIPQUR8n+badEWd+wWPEafZMApEWwjOUjEMfQi
	d4hR2TPWtYaHqKNV9iOv/P8Qy+/jEZrGpJz82k/djQwwcx0eulrEPkpBrsm9mMgpYWgDNOlr1Vw
	IYBx/xAOYG2eNyQ60dLg2SJbqhVktCB4=
X-Gm-Gg: AYBFou3BTd+snL4LIpItKW1kHzMTql0DAZnjviS4TtVBVKuj0xYG56/UJfU5RS/7WyP
	m38FqpMOXvLlHcB2r4NmYGA996mNiYZVyK4x/xq7CRC3yOa4FhwGKmxFdzzJSbp0s8bXCgznFVT
	wzerW5ZbCEjMQNW33bXgLv3/D5IxeIojyz8653TOquk73bY1FzAlwccLxD6j8Hj3YUUO5uAJpmR
	BaomA50JYMw/IStjuIzBN98ExY2KQM6H+aRuxKRakJ+VbtSvhHwkM0zsJ8QOaucQ/VRhBeYpPms
	pa+gcyuyQfOFR0aM7YBjqgU478KC4y/hJlgb6+c/3deH2S2NizRXYcfH/bAJEe/rmS4QGKMZhXB
	0dR9IhuK8P9wcf+rxkAUjopOy3LU+8dA36SE7D15nUybs/nOaEEIJ7MOqRa+Lpsfa+4XNLYcRvS
	+gBIhg0Amj3Jy0yv+l3Q==
X-Received: by 2002:a05:600c:506:b0:4a1:f377:5c6c with SMTP id
 5b1f17b1804b1-4bb55a5d6bbmr165067875e9.10.1794859644313; Mon, 16 Nov 2026
 12:07:24 -0800 (PST)
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Post: <mailto:linux-unionfs@vger.kernel.org>
List-Help: <mailto:linux-unionfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-unionfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261116-work-fs-frozen_writes-v2-0-ecc4a2aac40e@kernel.org> <20261116-work-fs-frozen_writes-v2-13-ecc4a2aac40e@kernel.org>
In-Reply-To: <20261116-work-fs-frozen_writes-v2-13-ecc4a2aac40e@kernel.org>
From: Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date: Mon, 16 Nov 2026 12:07:13 -0800
X-Gm-Features: Aa3M54rpWiCplKeR8o5TX-NbYGDID_36BWk-3VAyUzdEoXSYZ7J-t8pfWvm9Fcc
Message-ID: <CAEf4BzYANM9vtQ8L9-rJPQC-tTcw3YUGsw=qnCaoym3+EU=DBg@mail.gmail.com>
Subject: Re: [PATCH v2 13/17] bpf: fs/xattr: take freeze protection in the
 xattr kfuncs
To: Christian Brauner <brauner@kernel.org>
Cc: Jan Kara <jack@suse.cz>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Alexander Viro <viro@zeniv.linux.org.uk>, Jens Axboe <axboe@kernel.dk>, linux-fsdevel@vger.kernel.org, 
	linux-kernel@vger.kernel.org, io-uring@vger.kernel.org, 
	Christoph Hellwig <hch@lst.de>, linux-block@vger.kernel.org, linux-nvme@lists.infradead.org, 
	linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, 
	linux-unionfs@vger.kernel.org, bpf@vger.kernel.org, linux-nfs@vger.kernel.org, 
	stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Nov 16, 2026 at 3:13=E2=80=AFAM Christian Brauner <brauner@kernel.o=
rg> wrote:
>
> bpf_set_dentry_xattr() and bpf_remove_dentry_xattr() go through
> __vfs_setxattr() and __vfs_removexattr() which leave freeze protection
> to the caller. BPF LSM programs call them from sleepable hooks such as
> file_open where nobody holds it. So a program can modify a frozen
> filesystem.
>
> The hook may already hold freeze protection or locks a frozen
> filesystem would make us wait under. So don't wait for a thaw. Fail
> with -EBUSY if the filesystem is frozen.
>
> The _locked variants are only used from hooks that run inside setattr,
> setxattr, removexattr, unlink and rmdir. Their callers hold freeze
> protection already.
>
> Fixes: 56467292794b ("bpf: fs/xattr: Add BPF kfuncs to set and remove xat=
trs")
> Cc: stable@vger.kernel.org
> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
> ---
>  fs/bpf_fs_kfuncs.c | 8 ++++++++
>  1 file changed, 8 insertions(+)
>

LGTM

Acked-by: Andrii Nakryiko <andrii@kernel.org>

> diff --git a/fs/bpf_fs_kfuncs.c b/fs/bpf_fs_kfuncs.c
> index 35ccd98a4de64..7f61e2efa08ba 100644
> --- a/fs/bpf_fs_kfuncs.c
> +++ b/fs/bpf_fs_kfuncs.c
> @@ -295,9 +295,13 @@ __bpf_kfunc int bpf_set_dentry_xattr(struct dentry *=
dentry, const char *name__st
>         if (!inode)
>                 return -EINVAL;
>
> +       /* The hook may hold locks or freeze protection already. */
> +       if (!sb_start_write_trylock(inode->i_sb))
> +               return -EBUSY;
>         inode_lock(inode);
>         ret =3D bpf_set_dentry_xattr_locked(dentry, name__str, value_p, f=
lags);
>         inode_unlock(inode);
> +       sb_end_write(inode->i_sb);
>         return ret;
>  }
>
> @@ -323,9 +327,13 @@ __bpf_kfunc int bpf_remove_dentry_xattr(struct dentr=
y *dentry, const char *name_
>         if (!inode)
>                 return -EINVAL;
>
> +       /* The hook may hold locks or freeze protection already. */
> +       if (!sb_start_write_trylock(inode->i_sb))
> +               return -EBUSY;
>         inode_lock(inode);
>         ret =3D bpf_remove_dentry_xattr_locked(dentry, name__str);
>         inode_unlock(inode);
> +       sb_end_write(inode->i_sb);
>         return ret;
>  }
>
>
> --
> 2.53.0
>
>
