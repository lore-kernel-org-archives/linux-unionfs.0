Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C9F11C3F36;
	Wed, 28 Jan 2026 00:43:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769561026; cv=none; b=ZqpsKNV02wrOlz6h4O1mYDxx9ou4zhEqmzBfORV4EGpZsfBTkp2esXImG0FUv4JOSoB579hCfm4jcGZXgwa6OrVkj4Sc3Fc76atRHhM1ItYMcDIP3L+HPZ3KPpt0U3N+YsnduneJBxbC/BG6BqBC59pHRF77F+XaoNuDw3QJh1s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769561026; c=relaxed/simple;
	bh=04EMNhNYa+4moEOW8sybqj0nJHgWQ+jxOKjR1lfuE1A=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=E0AtE9QdQdjxN9z+zHznoxO4kHuutssNDYE8NC/wqCed50EZJa5GMuPiWhZcRJ6hSwJvWiX1W19i0S4Zsigp8/xuBKZKaP99lgsIbXekDjc176MGtsvQ3fGXN55gGR1UTKeTu+GCPzyIPsZLK5wbb0fs/s9WBLYDmXT7wRimnTU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=KU+BzG8W; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="KU+BzG8W"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 96BA2C116C6;
	Wed, 28 Jan 2026 00:43:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1769561025;
	bh=04EMNhNYa+4moEOW8sybqj0nJHgWQ+jxOKjR1lfuE1A=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=KU+BzG8WZweNDX2NvBmANiaj/5BVyP2NHDlfSqikeS9miA9sensOsL/ephKH2aCsc
	 4tmWlMwTiyiROk9JnvWSGcyD/fFVKIihdRhk06cg5OAq7tF2N7mesupNbHoDvuzwl4
	 hemBgOtRN4ceiwylIQs+KZQ75qHyw0AjNKJ7d72W3br8YG6AWLxzuWppQnDTOmKuKD
	 OjNRkVYsfbEzI7Qg7bKvoJX6ybE9ywzVl2uF58XXAo+sYO9ySDy9T4hqpGIvuy0u4d
	 0vnH+C9UUPuaYKAJacdFqO2lzjDRDCTRw38NnFCm8KAjw6OHb4RfDmQF1WzP1vZxDA
	 Eig0BXnbEZiYw==
Date: Tue, 27 Jan 2026 16:43:44 -0800
From: Eric Biggers <ebiggers@kernel.org>
To: Amir Goldstein <amir73il@gmail.com>
Cc: Qing Wang <wangqing7171@gmail.com>, miklos@szeredi.hu,
	linux-kernel@vger.kernel.org, linux-unionfs@vger.kernel.org,
	syzbot+d130f98b2c265fae5297@syzkaller.appspotmail.com,
	Christian Brauner <brauner@kernel.org>
Subject: Re: [PATCH v2] ovl: Fix uninit-value in ovl_fill_real
Message-ID: <20260128004344.GA2127@quark>
References: <CAJfpegt_n85jDSe9k9GcC_9KB=+R_oUeJTPt+3XSPkhjBPm3NQ@mail.gmail.com>
 <20260127105248.1485922-1-wangqing7171@gmail.com>
 <CAOQ4uxg2Zwuyorw50iKzwbQJO4wD2NfqhE21KPFZrDVMJAYzNQ@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOQ4uxg2Zwuyorw50iKzwbQJO4wD2NfqhE21KPFZrDVMJAYzNQ@mail.gmail.com>

On Tue, Jan 27, 2026 at 12:09:47PM +0100, Amir Goldstein wrote:
> Eric,
> 
> Considering that fscrypt_fname_alloc_buffer() anyway allocates the byte for NUL
> termination and that decrypted names are zero padded (right?).

Only when the length of the original filename isn't already a multiple
of the padding amount, as configured by FSCRYPT_POLICY_FLAGS_PAD_*.

> How about reinforcing this fix with:
> 
> diff --git a/fs/crypto/fname.c b/fs/crypto/fname.c
> index a9a4432d12ba1..97e00af49bb9f 100644
> --- a/fs/crypto/fname.c
> +++ b/fs/crypto/fname.c
> @@ -276,6 +276,7 @@ int fscrypt_fname_disk_to_usr(const struct inode *inode,
>         if (fscrypt_is_dot_dotdot(&qname)) {
>                 oname->name[0] = '.';
>                 oname->name[iname->len - 1] = '.';
> +               oname->name[iname->len] = 0;
>                 oname->len = iname->len;
>                 return 0;

Do you propose to do the same for all callers of dir_emit() in all
filesystems?  It seems not NUL-terminating the name is normal.  Just
usually the name is in the pagecache rather than slab memory, which
makes KMSAN not usually notice the out-of-bounds read in overlayfs.

- Eric
