Received: from mail-ej1-f48.google.com (mail-ej1-f48.google.com [209.85.218.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9EC4D3164A1
	for <linux-unionfs@vger.kernel.org>; Wed, 21 Jan 2026 19:00:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.218.48
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769022012; cv=pass; b=t2caIqnQlDb8R/uqwq78HBsWS2j0HnghtnO+zernnLg0VCFD3zsnNJq7ZBp+LsQNF6IMKftv/LeulA06H/P4ITXd2xthTpFZd8nwTBJsmKUd/sYIeQSEI0Ie2GYc4PhEiIVP7aqT+1jDslpvlUKrgOEkpx0ilU1NLpKul2l+0wk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769022012; c=relaxed/simple;
	bh=P50vKKEGRcti/ilk0zXXEyTeAkMnj2pLP0nOzx4jcho=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=pO72NGX6nTIj0joIH+3cAC+HRHD5OWjiU8dOol9xTsWvHBlZjlxJN6+pprjdJrNdcgr1FvtBw9eReq5DhQ+E/jMocmPEermLjjDfOQe4/M+6Vf8sb743issY3fkmP7xrx466RObw4CbMMtHyC+ZCYMZDc2o3EXtjq+Oj3VGdw9A=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ke3b0iRs; arc=pass smtp.client-ip=209.85.218.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ke3b0iRs"
Received: by mail-ej1-f48.google.com with SMTP id a640c23a62f3a-b8765b80a52so16331166b.2
        for <linux-unionfs@vger.kernel.org>; Wed, 21 Jan 2026 11:00:09 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1769022008; cv=none;
        d=google.com; s=arc-20240605;
        b=eFPQAGU5aHuUxh46NY+X2sNhBXLK/kdwCYFHwsZaxikyAdu62lON1xc20wSD4Lkckc
         QIbTRhnfax2iFwPBqtqcLJ8+ShkBMZ4iagY8EA9hpqSrtJyH1XU25+bh1/f7wHSI8Mlk
         NQyC+gJeGs1PiJofJZ05xaFNnmAev0RvEPfJ7C+WiAh5zucGVVmeubtM/2TpOMbRtr8/
         B1vlhOdznK3RaSZX94isCLTy6cdrhAwyQ14PTJ9Ka14/TGG1+xb+ad5VZwbyvAGugyqL
         GWvlyNL0lNe3+rm2cGh1zpvfsTWYErmc7t6rDHwgZ4SPo9wfd0L1Wx/IjXqnOOw4ZvDL
         zCmg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=P50vKKEGRcti/ilk0zXXEyTeAkMnj2pLP0nOzx4jcho=;
        fh=mR5mjrmbuCohpbJY9iRasJwxIu3GOvZowcdk7kyVbUI=;
        b=LJkHALbW2069BbCr0y7ZxKYkqHW6xEbHCLZxr5bQPe8d2EDHQE7r4Qm78Ymm5VJ/vZ
         O/dWchcuXqysG8A6RUamjUY9gZEoAE+uDsfyhW7Y2Ofx9Uut3r6u18zq3tDFtirWSvKU
         dFmaoXAnGP6sAaK50hH7piWUkYrfjQxQw6/pBUSdquh+jNvXYgGqt08pvhwgXkjnAgek
         YJXdHMU8Nfw5w7kczYfO+r/xosDZ3H2Iwcv5HwpxGOZsySx+r+z3Ah9E/wMDFozX5muM
         fO00axMt82E8+czDTG4DFO1x1+4vMI3m9aDL68yt9U+3zBLb3qGeiWWVNt7Zcrl9kePB
         jHPQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1769022008; x=1769626808; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=P50vKKEGRcti/ilk0zXXEyTeAkMnj2pLP0nOzx4jcho=;
        b=ke3b0iRsOPGdb9oGItiqf3p2ocGTfsItthso0F5B2fak03CUA0liWLn/Ve+kCx5qdQ
         JombE0ayrWVRZQXIZl23qp9IKs0OR39m8RilvLRQvVGHRFm30KkpG++OotWZ92AwuCGc
         mfAvUOj8NIFwo25zttpr2t9oiEAh7Td8L4n9JqF49lbt65BYqwZMpd8IuL+pjuR3w7Cx
         uwF7vQXLdVLV63Ny5cgNkQ66Jb7r0JOenkZbCMRNua5Ow/a8OGWNheD6DVKMa3a6U1VX
         hddDJM9Nq2Z5pHCrVaA1w4AG9WOs41axr0x1rUqjUrhki3bUl8DCRQXOnsnH+8mR9kKE
         KgeQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769022008; x=1769626808;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=P50vKKEGRcti/ilk0zXXEyTeAkMnj2pLP0nOzx4jcho=;
        b=DA4Fz7BKtnLv576WaKhymtC0sAfbHO8CJOy20BNwBNn4ok2swXi48L7Ce0xsBhnaSp
         8vygK25mRLOOZJbAnDMiZgl0W/2d5xCwYYRZU879Up0X79KYCukqGjQ8iPmnJbAxclaq
         vpUEGXI/kPfgnn8POhvKS3luYssDp9wjV/dPCnF7DuARau2exVLJNc+mG7QRZMB1viuu
         vTElCdeQOTZBa/JmZS+NCPoQo5dJWSKsd9TomyEQ7rdNEjQ8qTKuWazID9J3Wf5znpFp
         fQJuYe5x3OqnoXaBkqAL6o/C/gxeLJWKLsIBpNPJtmV5BNJUutWbc4kN96mmt8V7iAat
         cJXQ==
X-Forwarded-Encrypted: i=1; AJvYcCU79vutPJ434uZQ4MmQ1RNOAjeXIu5arUhV5YdPd1i6Vw+7ZiaBwQhbLUQJIYh0RAuxuJRmhEeRK8N8lXi9@vger.kernel.org
X-Gm-Message-State: AOJu0YyhmxBpZ+vr5iJQ+br2Qg1eKoaa2R8DtlcAtlxGGP8W2uVB7lm3
	R9KV75xOBlA72EZw3ifScy/lMK+7+sLJBcMAX/QVnx6eZtbYy2ZkRsu7GwbiqIm53ek0GRyslhj
	pEn/KTrzYdcKG0q5eZS8wkgePtcd77Ls=
X-Gm-Gg: AZuq6aIxLyMzSWBydBGhll5MP5kIfdtDq10z+T2qkSEyHnhTJLFSjWOomQ2rnVHa+l2
	uuB0e13Rjj4FtNXyZohhToQC4ggfhtqZ8FFTt8x4XUZ1l7GGU7df5g7v/m8kuff5X4CmyDw4la8
	3DTx7BLBYllRDoyhTIrEelrvmCS05f3deRIFyc028gt9mW8Z5zrijjYzmkSuATF5Frj8dBscdAm
	6PR2jm/vhHULHR3MpAf+ebpsmuFoYhHtCSirFOqINfg9jDC8iC4D7pY76oOoLarZlVnJsB70bKZ
	UFFnxMl56jfmEpcdJmYXScZcxCg=
X-Received: by 2002:a17:906:6a13:b0:b87:206a:a23b with SMTP id
 a640c23a62f3a-b8792f79852mr1477117366b.34.1769022007470; Wed, 21 Jan 2026
 11:00:07 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260115-exportfs-nfsd-v1-0-8e80160e3c0c@kernel.org>
 <CAOQ4uxjOJMwv_hRVTn3tJHDLMQHbeaCGsdLupiZYcwm7M2rm3g@mail.gmail.com>
 <9c99197dde2eafa55a1b55dce2f0d4d02c77340a.camel@kernel.org>
 <176877859306.16766.15009835437490907207@noble.neil.brown.name>
 <aW3SAKIr_QsnEE5Q@infradead.org> <176880736225.16766.4203157325432990313@noble.neil.brown.name>
 <20260119-kanufahren-meerjungfrau-775048806544@brauner> <176885553525.16766.291581709413217562@noble.neil.brown.name>
 <20260120-entmilitarisieren-wanken-afd04b910897@brauner> <176890211061.16766.16354247063052030403@noble.neil.brown.name>
 <20260120-hacken-revision-88209121ac2c@brauner> <a35ac736d9ebc6c92a6e7d61aeb5198234102442.camel@kernel.org>
 <176896790525.16766.11792073987699294594@noble.neil.brown.name> <ccb32c576cc4ebf943d5ec35e3d7ba4ae8892acd.camel@kernel.org>
In-Reply-To: <ccb32c576cc4ebf943d5ec35e3d7ba4ae8892acd.camel@kernel.org>
From: Amir Goldstein <amir73il@gmail.com>
Date: Wed, 21 Jan 2026 19:59:56 +0100
X-Gm-Features: AZwV_Qh050IhjThhArfxNo-53HjJR0uLCcITEQOtntS-75Lw875opD6ONQssxps
Message-ID: <CAOQ4uxg+dC1o+6V7Nvxf8UW3H=0OvsGjEe76LNY6q8ZcpGDDJw@mail.gmail.com>
Subject: Re: [PATCH 00/29] fs: require filesystems to explicitly opt-in to
 nfsd export support
To: Jeff Layton <jlayton@kernel.org>
Cc: NeilBrown <neil@brown.name>, Christian Brauner <brauner@kernel.org>, 
	Christoph Hellwig <hch@infradead.org>, Alexander Viro <viro@zeniv.linux.org.uk>, 
	Chuck Lever <chuck.lever@oracle.com>, Olga Kornievskaia <okorniev@redhat.com>, 
	Dai Ngo <Dai.Ngo@oracle.com>, Tom Talpey <tom@talpey.com>, Hugh Dickins <hughd@google.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Andrew Morton <akpm@linux-foundation.org>, 
	"Theodore Ts'o" <tytso@mit.edu>, Andreas Dilger <adilger.kernel@dilger.ca>, Jan Kara <jack@suse.com>, 
	Gao Xiang <xiang@kernel.org>, Chao Yu <chao@kernel.org>, Yue Hu <zbestahu@gmail.com>, 
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
	Jaegeuk Kim <jaegeuk@kernel.org>, linux-nfs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	linux-mm@kvack.org, linux-ext4@vger.kernel.org, linux-erofs@lists.ozlabs.org, 
	linux-xfs@vger.kernel.org, ceph-devel@vger.kernel.org, 
	linux-btrfs@vger.kernel.org, linux-cifs@vger.kernel.org, 
	linux-unionfs@vger.kernel.org, devel@lists.orangefs.org, 
	ocfs2-devel@lists.linux.dev, ntfs3@lists.linux.dev, 
	linux-nilfs@vger.kernel.org, jfs-discussion@lists.sourceforge.net, 
	linux-mtd@lists.infradead.org, gfs2@lists.linux.dev, 
	linux-f2fs-devel@lists.sourceforge.net
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Jan 21, 2026 at 12:56=E2=80=AFPM Jeff Layton <jlayton@kernel.org> w=
rote:
>
...
> > But if you really really want to set this new flag on almost every
> > export_operations, can I ask that you please set it on EVERY export
> > operations, then allow maintainers to remove it as they see fit.
> > I think that approach would be much easier to review.
> >
>
> We could probably do that, but I think the main ones that excludes it
> are kernfs, pidfs and nsfs. ovl and fuse also have export ops in
> certain modes that exclude NFS access, so the flag was left off of
> those as well.
>

For the record, my comments regarding fuse_export_fid_operations
and ovl_export_fid_operations variants were purely semantic -
it did not make sense to mark them as _STABLE_HANDLE, but
it does not matter if you set a flag on those ops, because they do
not implement ->fh_to_dentry(), on purpose, they are not
exportfs_can_decode_fh() by design.

Thanks,
Amir.
