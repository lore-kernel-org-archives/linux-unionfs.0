Received: from air.basealt.ru (air.basealt.ru [193.43.8.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80BEB1CCB2E;
	Tue, 19 Nov 2024 14:33:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=193.43.8.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732026797; cv=none; b=IXMYYZV1kG43RabFq5uVfKd4TCYU2RAp/q0mlEu30E8TiBy8Qm80u8Ct/q91twhNQCgIpIFaRVVFrVlrtD9lqAWvXx3ar+tW5f2eCDSpwH7/maRWB+AO0MrEl0W3Ek7BX52lirnXo9SRVZaBmOuNzDPkN6zSeU3+axBKoTcecJU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732026797; c=relaxed/simple;
	bh=VMovcccKe2b5MiZfiuwt4wD24V+KpnBgJC0eNiiVMBU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=XMTb6g70O3jXkslMJ8c41omrPS7ct1WqgaYTqyakVilASLIgLBM4a2YSe+qs9WBJPB8q8zNiXotxEvhPlAVoQOiCu0Lm45Ehx8+hH7CxoVclwIl59bXfSyYrMz+HS3jEFwkxOcqFdI/SsythL5vpat9Rah5hVSh8WqQVs8KQp3o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=altlinux.org; spf=pass smtp.mailfrom=altlinux.org; arc=none smtp.client-ip=193.43.8.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=altlinux.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=altlinux.org
Received: from [192.168.0.103] (unknown [178.76.204.78])
	by air.basealt.ru (Postfix) with ESMTPSA id 90315233A7;
	Tue, 19 Nov 2024 17:33:04 +0300 (MSK)
Message-ID: <6fb27fea-3998-0fdf-9210-d7479baf0570@basealt.ru>
Date: Tue, 19 Nov 2024 17:33:03 +0300
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.0
Subject: Re: [PATCH] ovl: Add check for missing lookup operation on inode
To: Miklos Szeredi <miklos@szeredi.hu>, Amir Goldstein <amir73il@gmail.com>
Cc: Vasiliy Kovalev <kovalev@altlinux.org>, linux-unionfs@vger.kernel.org,
 linux-kernel@vger.kernel.org
References: <20241118141703.28510-1-kovalev@altlinux.org>
 <CAOQ4uxjxXHX4j=4PbUFrgDoDYEZ1jkjD1EAFNxf1at44t--gHg@mail.gmail.com>
 <CAJfpegvx-oS9XGuwpJx=Xe28_jzWx5eRo1y900_ZzWY+=gGzUg@mail.gmail.com>
Content-Language: en-US
From: Vasiliy Kovalev <kovalev@altlinux.org>
In-Reply-To: <CAJfpegvx-oS9XGuwpJx=Xe28_jzWx5eRo1y900_ZzWY+=gGzUg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Hi,

19.11.2024 12:05, Miklos Szeredi wrote:
> On Mon, 18 Nov 2024 at 19:54, Amir Goldstein <amir73il@gmail.com> wrote:
> 
>> Can you analyse what went wrong with the reproducer?
>> How did we get to a state where lowerstack of parent
>> has a dentry which is !d_can_lookup?
> 
> Theoretically we could still get a an S_ISDIR inode, because
> ovl_get_inode() doesn't look at the is_dir value that lookup found.
> I.e. lookup thinks it found a non-dir, but iget will create a dir
> because of the backing inode's type.
> 
> AFAICS this can only happen if i_op->lookup is not set on S_ISDIR for
> the backing inode, which shouldn't happen on normal filesystems.
> Reproducer seems to use bfs, which *should* be normal, and bfs_iget
> certainly doesn't do anything weird in that case, so I still don't
> understand what is happening.

During testing, it was discovered that BFS can return a directory inode 
without a lookup operation.  Adding the following check in bfs_iget:

struct inode *bfs_iget(struct super_block *sb, unsigned long ino)
{

...
	brelse(bh);

+	if (S_ISDIR(inode->i_mode) && !inode->i_op->lookup) {
+		printf("Directory inode missing lookup %s:%08lx\n",
						inode->i_sb->s_id, ino);
+		goto error;
+	}
+
	unlock_new_inode(inode);
	return inode;

error:
	iget_failed(inode);
	return ERR_PTR(-EIO);
}

prevents the error but exposes an invalid inode:

loop0: detected capacity change from 0 to 64
BFS-fs: bfs_iget(): Directory inode missing lookup loop0:00000002
overlayfs: overlapping lowerdir path

Would this be considered a valid workaround, or does BFS require further 
fixes?

> In any case something like the following should filter out such weirdness:
> 
>   bool ovl_dentry_weird(struct dentry *dentry)
>   {
> +       if (!d_can_lookup(dentry) && !d_is_file(dentry) &&
> !d_is_symlink(dentry))
> +               return true;
> +
>          return dentry->d_flags & (DCACHE_NEED_AUTOMOUNT |

I tested this addition successfully.

Additionally, fixes for BFS seem to be discussed reluctantly.
For instance, this patch set [1] has remained unanswered.
Perhaps it would be worth considering discarding invalid inodes at the 
overlayfs level?

[1] 
https://lore.kernel.org/all/20240822161219.459054-1-kovalev@altlinux.org/

> Thanks,
> Miklos
--
Thanks,
Vasiliy Kovalev
