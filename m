Received: from mail-wr1-f48.google.com (mail-wr1-f48.google.com [209.85.221.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48FA73D1CAA
	for <linux-unionfs@vger.kernel.org>; Thu, 15 Jan 2026 18:54:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768503273; cv=none; b=R2HLqV0FObGdQNJZvd/2RR3Av4geYuTzeVpjQrt+zttD5/FRDY4RxMkPfHzWkoGvqntwLj4FJGP723LtN0rGRSXyEP4cW+nrAeSnX+sueVbTTYiSNKxvcpRSeIgvNrqB78xjAj1lWAeWLCAbdvDLzlp5UWW2e8MW10+bDIZ7I0A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768503273; c=relaxed/simple;
	bh=AgB8BlDrSqCt2vWmdgQdkVNbgorviCbIMxtlMVxqyDU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=NB0WraPNtu3ca0Qrjj6Ei9gOGemhWlwDo9vtk+3yZ/wuNFeOBNpK7Y2Pw6CNsIZbylD5k6FxiEgfmFiDEVLgSw43x9JYdodZbMiIA+pNhhKwpGnTz6VGHtNliPJ+OQ4RSVVyoOoBJE3Lj9r2WdXByBdjQ8U8lfeu54jNFT+Dge4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=MSUUWslM; arc=none smtp.client-ip=209.85.221.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="MSUUWslM"
Received: by mail-wr1-f48.google.com with SMTP id ffacd0b85a97d-4308d81fdf6so770017f8f.2
        for <linux-unionfs@vger.kernel.org>; Thu, 15 Jan 2026 10:54:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1768503269; x=1769108069; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=R/pIR9g5xBWqOZmQj/jDCO8xKQONNisoQQHHakrcMdk=;
        b=MSUUWslM7So/8e5qCKM9JU2cE4putYAvpi8UdtuonqryPMUNC+1PUocWSNmRX6iGft
         Llsnn4u2ChuSQFRjdQYh1n4dcKLsda/c9h8OBQlFkmYO6AbGHtLLYM0SAWhirNpaoF4n
         lakVf7f1knSaC/T5LidHJsjH0TVakBR0PiniEdlaUsoRuFln+7VFqUwQfgRz0i4x4AvS
         ZYRXMKaX2NnbWxFRzsRhO2KaJ3DxCOuFwkiLa7v70xNShq3EGNuiEqzLBa7apuvs8Ev8
         8lR89uWCNysQXzJycZ3fgJA46czSOxtOhpmR8aUQ39pBmNkdExztbB4bfrrOFL9eSKRt
         1A2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768503269; x=1769108069;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=R/pIR9g5xBWqOZmQj/jDCO8xKQONNisoQQHHakrcMdk=;
        b=JNrIBxSSqNralMXLnKyt/Yaq3LaLl8K+ddEjoeAWhJmsvcD/6hYa6DVpFkvZT6eSQp
         6q3HErChXnEhM8Rd3xcho+FR/0YLaqzRqz0QOcyZ/gQG1fE6PwM8Bg6JQEpJfncxQO+L
         Lody7lWzMSvrJN8Y/dHaaAwpGzipGc8lzb4NlN4ENsyVzhfpfzherBGetfcGdh7pebSF
         nlvvqwLMjtJzXp0I7vc7MqfKc6Gve1NeSDkg2Yl7PIYwf4LO/EVYgd1L8zSNVJ/bMoSu
         iHFOlZIlTLPyAzSjgXGbK8z12CQQHSmzdNRBVauO1JzGRtCa2K0WOfEeAhJgdH1xQui6
         EF8A==
X-Forwarded-Encrypted: i=1; AJvYcCUY0sp7x+SmhUIDASlj22JhHosvUt4cK0mq3GODW1n5fdyegAYimLeGsp+FF8R/jKrEad5MfxhUuJN75YUc@vger.kernel.org
X-Gm-Message-State: AOJu0YzqHhclIA8fTTbY/4hT0+gwWbatpIy6xSKJUMzgYdSgS1Abdnrs
	Gq8GjnaILkKqbP7VtqjI/Mm81zSYMKqYb20lagpx/olQwADbk3DvOwYFXELW+nZJpr+oh7kgH+P
	nl72zEeN5TAB1vFFwZAg02xt6uxzY5o4=
X-Gm-Gg: AY/fxX5V0JE4HtZj4dX5VPDihgi776cDotfBrVogi1lBtX5fxvVRHsZlGsDahZx7GCo
	jFHTXGVIuWMqU7IWMw1moHDFVavt5TDzbPQNNCYcVCYE0VjvA96B0ng/bQ5siHI1Q8y7NXI0ioO
	WSZxkw+IlplbvSVxdrS8c6m4a4aUbqMhTS0Wec66bTjFfDCtKlHjpi0nMKk/YE3CZoj36ZEXsbs
	w/Dft2ndgRMORY+Ie6lLFuQiRIPWHx6zB3zaFvaGtEy7r2JAm+BgE5Jv9hXoajzGepTP/ht6pzg
	IcZGEKI24+t3mDCzkS3ANK2aYlKJOg==
X-Received: by 2002:a05:6000:2313:b0:432:5c43:76 with SMTP id
 ffacd0b85a97d-43569bc17ebmr434376f8f.39.1768503268480; Thu, 15 Jan 2026
 10:54:28 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260115-exportfs-nfsd-v1-0-8e80160e3c0c@kernel.org> <20260115-exportfs-nfsd-v1-26-8e80160e3c0c@kernel.org>
In-Reply-To: <20260115-exportfs-nfsd-v1-26-8e80160e3c0c@kernel.org>
From: Amir Goldstein <amir73il@gmail.com>
Date: Thu, 15 Jan 2026 19:54:17 +0100
X-Gm-Features: AZwV_QgNgqINU2MW0ct-_EKOImgQ1uAwJfq7nKBHPoIgHpyzlMCSNbXGV-6zTEg
Message-ID: <CAOQ4uxh4VaVL9PD7-_Op9Xs-z5Qrx8g6x2x5FccujQX-Cw9RqQ@mail.gmail.com>
Subject: Re: [PATCH 26/29] fuse: add EXPORT_OP_STABLE_HANDLES flag to export operations
To: Jeff Layton <jlayton@kernel.org>
Cc: Christian Brauner <brauner@kernel.org>, Alexander Viro <viro@zeniv.linux.org.uk>, 
	Chuck Lever <chuck.lever@oracle.com>, NeilBrown <neil@brown.name>, 
	Olga Kornievskaia <okorniev@redhat.com>, Dai Ngo <Dai.Ngo@oracle.com>, Tom Talpey <tom@talpey.com>, 
	Hugh Dickins <hughd@google.com>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
	Andrew Morton <akpm@linux-foundation.org>, "Theodore Ts'o" <tytso@mit.edu>, 
	Andreas Dilger <adilger.kernel@dilger.ca>, Jan Kara <jack@suse.com>, Gao Xiang <xiang@kernel.org>, 
	Chao Yu <chao@kernel.org>, Yue Hu <zbestahu@gmail.com>, 
	Jeffle Xu <jefflexu@linux.alibaba.com>, Sandeep Dhavale <dhavale@google.com>, 
	Hongbo Li <lihongbo22@huawei.com>, Chunhai Guo <guochunhai@vivo.com>, 
	Carlos Maiolino <cem@kernel.org>, Ilya Dryomov <idryomov@gmail.com>, Alex Markuze <amarkuze@redhat.com>, 
	Viacheslav Dubeyko <slava@dubeyko.com>, Chris Mason <clm@fb.com>, David Sterba <dsterba@suse.com>, 
	Luis de Bethencourt <luisbg@kernel.org>, Salah Triki <salah.triki@gmail.com>, 
	Phillip Lougher <phillip@squashfs.org.uk>, Steve French <sfrench@samba.org>, 
	Paulo Alcantara <pc@manguebit.org>, Ronnie Sahlberg <ronniesahlberg@gmail.com>, 
	Shyam Prasad N <sprasad@microsoft.com>, Bharath SM <bharathsm@microsoft.com>, 
	Miklos Szeredi <miklos@szeredi.hu>, Mike Marshall <hubcap@omnibond.com>, 
	Martin Brandenburg <martin@omnibond.com>, Mark Fasheh <mark@fasheh.com>, Joel Becker <jlbec@evilplan.org>, 
	Joseph Qi <joseph.qi@linux.alibaba.com>, 
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>, 
	Ryusuke Konishi <konishi.ryusuke@gmail.com>, Trond Myklebust <trondmy@kernel.org>, 
	Anna Schumaker <anna@kernel.org>, Dave Kleikamp <shaggy@kernel.org>, 
	David Woodhouse <dwmw2@infradead.org>, Richard Weinberger <richard@nod.at>, Jan Kara <jack@suse.cz>, 
	Andreas Gruenbacher <agruenba@redhat.com>, OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>, 
	Jaegeuk Kim <jaegeuk@kernel.org>, Christoph Hellwig <hch@infradead.org>, linux-nfs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	linux-mm@kvack.org, linux-ext4@vger.kernel.org, linux-erofs@lists.ozlabs.org, 
	linux-xfs@vger.kernel.org, ceph-devel@vger.kernel.org, 
	linux-btrfs@vger.kernel.org, linux-cifs@vger.kernel.org, 
	samba-technical@lists.samba.org, linux-unionfs@vger.kernel.org, 
	devel@lists.orangefs.org, ocfs2-devel@lists.linux.dev, ntfs3@lists.linux.dev, 
	linux-nilfs@vger.kernel.org, jfs-discussion@lists.sourceforge.net, 
	linux-mtd@lists.infradead.org, gfs2@lists.linux.dev, 
	linux-f2fs-devel@lists.sourceforge.net
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Jan 15, 2026 at 6:50=E2=80=AFPM Jeff Layton <jlayton@kernel.org> wr=
ote:
>
> Add the EXPORT_OP_STABLE_HANDLES flag to fuse export operations to indica=
te
> that this filesystem can be exported via NFS.
>
> Signed-off-by: Jeff Layton <jlayton@kernel.org>
> ---
>  fs/fuse/inode.c | 2 ++
>  1 file changed, 2 insertions(+)
>
> diff --git a/fs/fuse/inode.c b/fs/fuse/inode.c
> index 819e50d666224a6201cfc7f450e0bd37bfe32810..1652a98db639fd75e8201b681=
a29c68b4eab093c 100644
> --- a/fs/fuse/inode.c
> +++ b/fs/fuse/inode.c
> @@ -1208,6 +1208,7 @@ static struct dentry *fuse_get_parent(struct dentry=
 *child)
>  /* only for fid encoding; no support for file handle */
>  static const struct export_operations fuse_export_fid_operations =3D {
>         .encode_fh      =3D fuse_encode_fh,
> +       .flags          =3D EXPORT_OP_STABLE_HANDLES,
>  };

These are used when the server declares FUSE_NO_EXPORT_SUPPORT
so do not opt in for NFS export.

The sad thing w.r.t FUSE is that in most likelihood server does not provide
persistent handles also when it does not declare FUSE_NO_EXPORT_SUPPORT
but we are stuck with that.

Thanks,
Amir.
