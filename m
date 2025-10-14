Received: from mail-wr1-f41.google.com (mail-wr1-f41.google.com [209.85.221.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1A89285C99
	for <linux-unionfs@vger.kernel.org>; Tue, 14 Oct 2025 05:26:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760419571; cv=none; b=ZtU1usPoXF25+nJpnNouXuH3E6NJzzAgyXWqCKOjcF3D/bABmmEa7/z7gcEgDgmsjIxojSM3ZfFN6WXDkdNPTy1+/xPUZLxzlowusU9Uad6kf94PLpsrvbUG7T0g4N3+1IUHWjVllah9Lb9fMtLAJ6VMTToAfRzECtXzqTlS1zg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760419571; c=relaxed/simple;
	bh=RzZ2rpgYX4TU7MT3Xglqz4bP41cT5Oh6ggAKNbiU4Qg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=WdNV9RJmwWV7V2+7NacCZGOtiT8Z3JCV/4YJiq5qNav3egg+jMagtZGECy0G2xORzkkGOL4xTkNL5hBoRs9AR2agcipqml9+qh8cfxIwEV449LlL4jbGTLhe6OflNWDS6lrkiStrtyCSYNLItFwGyZ27BjZhqs114o3353YDcd8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=TMa9tT67; arc=none smtp.client-ip=209.85.221.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="TMa9tT67"
Received: by mail-wr1-f41.google.com with SMTP id ffacd0b85a97d-4060b4b1200so3648521f8f.3
        for <linux-unionfs@vger.kernel.org>; Mon, 13 Oct 2025 22:26:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1760419568; x=1761024368; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=PJeA08PmXO0Rt+J6zqTRksSe9Q2LhvStVnJgFH8knlE=;
        b=TMa9tT67BZUz1dqoyEp7c7boJbzouJq/CFRT9LOK/U9xCWA5vMvOBkUMWgn1smAdp2
         Brts+rKceBUpEtfxGyevkKllE57ptajVK/Eu+A8iHkucCdATPSb7WIDXOtz6HOW+wi8c
         b1G1G1SGA/0IJoBMYoH4XBtKaYKWhWcsl9aYGRNKlerxCDvmJYHTMEreFgZEsBR8Pczy
         DqEx2WUacQh4R5Seu9dNoTTBFl7ELoBSytZUQrIisqCRVSA365p2yHsi0zsaQBMQuVbb
         E3kJOKe+LmCfVnqJnKd7m34sLRZxcDWH0bJ10MP4uqwq0ZluEixXFBM1cuY/BJQNMCc+
         o85g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760419568; x=1761024368;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=PJeA08PmXO0Rt+J6zqTRksSe9Q2LhvStVnJgFH8knlE=;
        b=IJzCr5CEjGnY2oSRtMkb9RFCxxUbYcBGIjotmnF3278zsItd55BU/CzwMnj+VC99h7
         nXcJvAYddFkNP8lY4bAAY2RMlifQ3od3n9IfoRQ4ly320ekc4fwq3yNQdMyt/c432I1Z
         dyHues++4pjbzpGxoDHGppGDN9SvszhHeGmlbmBRvUD3H+NghsqYCyumwvIjN1HwsrGo
         eG8XHLvPwQNBdyFA4pnKjKoRXE3s7Amkf62M2H/ZKaKz3R46Qmw6nz71OHbphNQ7wSpD
         sL7p6gHORMHjbfE2PJ5SNaxAOWoTFxSMJjZOKIE+slXhxCLAucAxf5q9pZKCrcbZx3HY
         KKfQ==
X-Forwarded-Encrypted: i=1; AJvYcCXUIJuX/c9gQvzNGkAgO24mC2BFRlxZB+7ao007V2lg1vOAEAwKygZCCGUz7SLgGljLMUV/S6m/iZQSgrnK@vger.kernel.org
X-Gm-Message-State: AOJu0Yy5zY6RLmbnwYetHW/YZa44lhkqb3cu5f489AK3qk8d8yV8TaH1
	SaHEzCyZ80K4hliYcZNjPOhoVBFUS2sgd3wDVyUB8oY8H/j+5aTdeyIVih8BagCe0BI9Lxf7cuM
	baDDZ4zE=
X-Gm-Gg: ASbGncviL/okzxWNPpeiOAHv27bU+Lx3jdv5zctSYHCC5hTDGX6NlljC9G71PfmqQY8
	ggI2nwt2pH9VHYxTa0HK29dy5cA7NFG4aMB5/Pe5M0JmWG6BzftX9RUldh2vpTwV1dQ3aX8RwTQ
	sFE00R+v5Qny8pVx2jUoUkyBv0VWwcnr/7UR5z6HDdKefjfeiSgGgPkQzNtozwjyC/r1x0XYeP2
	rj1QnSWdomI9gx61u1ELpMbkAirg9KWPhmQX/Cq7WNDZTCKqCkuV1sRbR8upg8YkKFbBZyAT09e
	JacM/NrJ4u12BVCRLrWSKmEEmQU4LbkikNgoD1NlJy8fNtRDTWmToi4pYIWWFYFom8cPT5h7AY8
	miQ4oAoihHag6LlDvIxygC6PecVQ7AsLjOeJbIOqaAZB2j82BqcXXddhYu9iErR3+YJOqet2U8i
	iVBO2k
X-Google-Smtp-Source: AGHT+IGrGpGhcI95c5DMP672QlHISusRMmNdSZjfnjcUd//Uku5n9Mpyuwa8gnooQRqjnAoP2rIKaA==
X-Received: by 2002:a05:6000:2505:b0:3ee:1279:6e68 with SMTP id ffacd0b85a97d-42672425b82mr14532469f8f.47.1760419567943;
        Mon, 13 Oct 2025 22:26:07 -0700 (PDT)
Received: from ?IPV6:2403:580d:fda1::299? (2403-580d-fda1--299.ip6.aussiebb.net. [2403:580d:fda1::299])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-29034de6c14sm151516595ad.6.2025.10.13.22.26.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 13 Oct 2025 22:26:07 -0700 (PDT)
Message-ID: <f6d30bb5-8e0e-4351-a11f-4a78f7a541e7@suse.com>
Date: Tue, 14 Oct 2025 15:56:00 +1030
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH 0/1] ovl: brtfs' temp_fsid doesn't work with ovl
 index=on
To: =?UTF-8?Q?Andr=C3=A9_Almeida?= <andrealmeid@igalia.com>,
 linux-kernel@vger.kernel.org, linux-btrfs@vger.kernel.org,
 linux-unionfs@vger.kernel.org, linux-fsdevel@vger.kernel.org
Cc: kernel-dev@igalia.com, Miklos Szeredi <miklos@szeredi.hu>,
 Amir Goldstein <amir73il@gmail.com>, Chris Mason <clm@fb.com>,
 David Sterba <dsterba@suse.com>, Anand Jain <anand.jain@oracle.com>,
 "Guilherme G . Piccoli" <gpiccoli@igalia.com>
References: <20251014015707.129013-1-andrealmeid@igalia.com>
Content-Language: en-US
From: Qu Wenruo <wqu@suse.com>
Autocrypt: addr=wqu@suse.com; keydata=
 xsBNBFnVga8BCACyhFP3ExcTIuB73jDIBA/vSoYcTyysFQzPvez64TUSCv1SgXEByR7fju3o
 8RfaWuHCnkkea5luuTZMqfgTXrun2dqNVYDNOV6RIVrc4YuG20yhC1epnV55fJCThqij0MRL
 1NxPKXIlEdHvN0Kov3CtWA+R1iNN0RCeVun7rmOrrjBK573aWC5sgP7YsBOLK79H3tmUtz6b
 9Imuj0ZyEsa76Xg9PX9Hn2myKj1hfWGS+5og9Va4hrwQC8ipjXik6NKR5GDV+hOZkktU81G5
 gkQtGB9jOAYRs86QG/b7PtIlbd3+pppT0gaS+wvwMs8cuNG+Pu6KO1oC4jgdseFLu7NpABEB
 AAHNGFF1IFdlbnJ1byA8d3F1QHN1c2UuY29tPsLAlAQTAQgAPgIbAwULCQgHAgYVCAkKCwIE
 FgIDAQIeAQIXgBYhBC3fcuWlpVuonapC4cI9kfOhJf6oBQJnEXVgBQkQ/lqxAAoJEMI9kfOh
 Jf6o+jIH/2KhFmyOw4XWAYbnnijuYqb/obGae8HhcJO2KIGcxbsinK+KQFTSZnkFxnbsQ+VY
 fvtWBHGt8WfHcNmfjdejmy9si2jyy8smQV2jiB60a8iqQXGmsrkuR+AM2V360oEbMF3gVvim
 2VSX2IiW9KERuhifjseNV1HLk0SHw5NnXiWh1THTqtvFFY+CwnLN2GqiMaSLF6gATW05/sEd
 V17MdI1z4+WSk7D57FlLjp50F3ow2WJtXwG8yG8d6S40dytZpH9iFuk12Sbg7lrtQxPPOIEU
 rpmZLfCNJJoZj603613w/M8EiZw6MohzikTWcFc55RLYJPBWQ+9puZtx1DopW2jOwE0EWdWB
 rwEIAKpT62HgSzL9zwGe+WIUCMB+nOEjXAfvoUPUwk+YCEDcOdfkkM5FyBoJs8TCEuPXGXBO
 Cl5P5B8OYYnkHkGWutAVlUTV8KESOIm/KJIA7jJA+Ss9VhMjtePfgWexw+P8itFRSRrrwyUf
 E+0WcAevblUi45LjWWZgpg3A80tHP0iToOZ5MbdYk7YFBE29cDSleskfV80ZKxFv6koQocq0
 vXzTfHvXNDELAuH7Ms/WJcdUzmPyBf3Oq6mKBBH8J6XZc9LjjNZwNbyvsHSrV5bgmu/THX2n
 g/3be+iqf6OggCiy3I1NSMJ5KtR0q2H2Nx2Vqb1fYPOID8McMV9Ll6rh8S8AEQEAAcLAfAQY
 AQgAJgIbDBYhBC3fcuWlpVuonapC4cI9kfOhJf6oBQJnEXWBBQkQ/lrSAAoJEMI9kfOhJf6o
 cakH+QHwDszsoYvmrNq36MFGgvAHRjdlrHRBa4A1V1kzd4kOUokongcrOOgHY9yfglcvZqlJ
 qfa4l+1oxs1BvCi29psteQTtw+memmcGruKi+YHD7793zNCMtAtYidDmQ2pWaLfqSaryjlzR
 /3tBWMyvIeWZKURnZbBzWRREB7iWxEbZ014B3gICqZPDRwwitHpH8Om3eZr7ygZck6bBa4MU
 o1XgbZcspyCGqu1xF/bMAY2iCDcq6ULKQceuKkbeQ8qxvt9hVxJC2W3lHq8dlK1pkHPDg9wO
 JoAXek8MF37R8gpLoGWl41FIUb3hFiu3zhDDvslYM4BmzI18QgQTQnotJH8=
In-Reply-To: <20251014015707.129013-1-andrealmeid@igalia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



在 2025/10/14 12:27, André Almeida 写道:
> Hi everyone,
> 
> When using overlayfs with the mount option index=on, the first time a directory is
> used as upper dir, overlayfs stores in a xattr "overlay.origin" the UUID of the
> filesystem being used in the layers. If the upper dir is reused, overlayfs
> refuses to mount for a different filesystem, by comparing the UUID with what's
> stored at overlay.origin, and it fails with "failed to verify upper root origin"
> on dmesg. Remounting with the very same fs is supported and works fine.
> 
> However, btrfs mounts may have volatiles UUIDs. When mounting the exact same
> disk image with btrfs, a random UUID is assigned for the following disks each
> time they are mounted, stored at temp_fsid and used across the kernel as the
> disk UUID. `btrfs filesystem show` presents that. Calling statfs() however shows
> the original (and duplicated) UUID for all disks.

Yep, that's the btrfs' hack to allowing mounting cloned devices (as long 
as they are all single-device only btrfs)

Although I'm not a huge fan for that, without that you can not even 
mount any cloned btrfs in the first place.

> 
> This feature doesn't work well with overlayfs with index=on, as when the image
> is mounted a second time, will get a different UUID and ovl will refuse to
> mount, breaking the user expectation that using the same image should work. A
> small script can be find in the end of this cover letter that illustrates this.
> 
>  From this, I can think of some options:
> 
> - Use statfs() internally to always get the fsid, that is persistent. The patch
> here illustrates that approach, but doesn't fully implement it.
> - Create a new sb op, called get_uuid() so the filesystem returns what's
> appropriated.
> - Have a workaround in ovl for btrfs.
> - Document this as unsupported, and userland needs to erase overlay.origin each
> time it wants to remount.
> - If ovl detects that temp_fsid and index are being used at the same time,
> refuses to mount.

Or, let btrfs to reject the cloned device in the first place.

> 
> I'm not sure which one would be better here, so I would like to hear some ideas
> on this.
> 
> Thanks!
> 	André
> 
> ---
> 
> To reproduce:
> 
> mkdir -p dir1 dir2
> 
> fallocate -l 300m ./disk1.img
> mkfs.btrfs -q -f ./disk1.img
> 
> # cloning the disks
> cp disk1.img disk2.img

If you really want to use the same copied fs, at least you can use
`btrfstune -m disk2.img` to change it to a new metadata uuid (without 
re-writing all metadata).

Then everything should work.

Thanks,
Qu
> sudo mount -o loop ./disk1.img dir1
> sudo mount -o loop ./disk2.img dir2
> 
> mkdir -p dir2/lower aux/upper aux/work
> 
> # this works
> sudo mount -t overlay -o lowerdir=dir2/lower,upperdir=aux/upper,workdir=aux/work,userxattr none dir2/lower
> 
> sudo umount dir2/lower
> sudo umount dir2
> 
> sudo mount -o loop ./disk2.img dir2
> 
> # this doesn't works
> sudo mount -t overlay -o lowerdir=dir2/lower,upperdir=aux/upper,workdir=aux/work,userxattr none dir2/lower
> 
> André Almeida (1):
>    ovl: Use fsid as unique identifier for trusted origin
> 
>   fs/overlayfs/copy_up.c | 8 +++++++-
>   1 file changed, 7 insertions(+), 1 deletion(-)
> 

