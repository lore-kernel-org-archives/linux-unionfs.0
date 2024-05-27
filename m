Received: from mail-ed1-f47.google.com (mail-ed1-f47.google.com [209.85.208.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 266A5FC02
	for <linux-unionfs@vger.kernel.org>; Mon, 27 May 2024 05:27:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716787632; cv=none; b=NuJKeyyW+7BgCgKWDZshMMBTGiKJjCXuJ60/0CUzZHc5g1ELdXpT1GQwdil7lV9lvKzSzGrxXlNlcGu+gX9jnsr7ay6rfB8rk/TO1Yp2TpZH6FbjBJ53I/g1Y0KVzpmvKNP2G7kZmM9plsRhvNIKPK4cSaGhpTOtdM3dvCqLwCM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716787632; c=relaxed/simple;
	bh=dY168D3djRjWqN3Nqp3O01eSEb9o52DxnfkxveJLESA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=jANq5FbaOXkj9SnbYk0Vz2m3Qkaavi+QYnQYqP7As4slPqZtwcb7xtXYGwD9J2IL1Owx+YHgtb09SL4mCEQrBQ1ubhOjF/IBuYob/1BFj2sh6211FyjZ3e7wY5PNx0CQYR8RSzkiJaUgWwCSghVc6oxjESiRlhccEhU1BmtR4cU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=h/7fUb02; arc=none smtp.client-ip=209.85.208.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="h/7fUb02"
Received: by mail-ed1-f47.google.com with SMTP id 4fb4d7f45d1cf-57857e0f45cso2668431a12.1
        for <linux-unionfs@vger.kernel.org>; Sun, 26 May 2024 22:27:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1716787629; x=1717392429; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=5aQ2V1pBSOM4wgN+3FxRURExuuAhVm0HDJDx5ukaTH4=;
        b=h/7fUb02L6r+iy834OaEUb1vmRTbH2hbcERdTWWRrPzsW8doZbAlX96bdOKU+TfGk4
         Uqp6RLZwL9ErCBllMzjxdnK8ydVg287PE91ZyfmqjGbXCo5bSG/or0Ax0XS5xgO2pQ+y
         je3fyPeLgHzKvzZi+WZ9/bNduMkDVfCaokrpsWKs/CR5hcAFXht/vc6vaTSvtr8qRqS6
         kKeDl9P8Kg6SsvL68ri8YzLIFG6Pmxsm+kWKTU4ZkwTfc63ppHpsUIlrVsd4iPIoWc7r
         zEbxDzLAyMyvUrCu1WsTv0UKQ+44QtXHJrv4gACjbaP01AkFxOgcybBsyxrnSFT5oUU3
         Avdg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1716787629; x=1717392429;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=5aQ2V1pBSOM4wgN+3FxRURExuuAhVm0HDJDx5ukaTH4=;
        b=fb7BxmRyYSx3dd/+cjKa5sHO/rg9QSVOJOzTOkq3q7qcw86TB4gp6Xz5zcpAzrHdCw
         f6zSzzRXaLeSNKwpKG2/UTTKUoJGno93A3es7HzI5BVUvRqvEHiG3wjLFIdRxdFGK+Xh
         QG+hK12CWCq/HgV//HumMpv0d53NFqqhK5JEHIL+Alx+tlUBYEvjLbym5VLUNEUhZVar
         XJ3zi4mq8scmK0jPMk1pH0mVpELTblNoGcLiSmt+t8REZ8hCc28oxd7M7NVGEeYhLrfW
         0eq7+4pld+0c2lYCqRCAYw5VbgUPqinpOU8FR913jDfUtu2TuaTKJ6iDr622kTHEUYAA
         6wMg==
X-Forwarded-Encrypted: i=1; AJvYcCVmpYe00uvpWiJLdshPwxLNkiAMfvJBlbDgKNaKIImJRV5054+gzVXPywt51TXJbs3xb37iLldezq0oiZju2wah0nRxIXhgB7n9Ta/1HQ==
X-Gm-Message-State: AOJu0YwyCzVT4gNBCpgd1MaXtxt/8UgPqHe54erQtlvV0hWwQeVMmbvg
	GHY4srCwowQ/IQDU25IO1m5jBBz4FCJ7P0kDb7pd0qV32y4SyOXRHUKoqxGqTEG8/A==
X-Google-Smtp-Source: AGHT+IFqCFIYZVc05kXjCFNyNB8JnIV7MBOCfe9HPGbeV+SrrK5fVdpEO9uvwJ81MfTSZLNBChDtjg==
X-Received: by 2002:a50:d68b:0:b0:572:6846:b899 with SMTP id 4fb4d7f45d1cf-578519ba7abmr5025590a12.41.1716787629139;
        Sun, 26 May 2024 22:27:09 -0700 (PDT)
Received: from [10.8.0.6] (dslb-088-074-221-144.088.074.pools.vodafone-ip.de. [88.74.221.144])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-57852495de0sm5240454a12.61.2024.05.26.22.27.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 26 May 2024 22:27:08 -0700 (PDT)
Message-ID: <f0554eae-215b-4314-b731-51fd8eca1369@gmail.com>
Date: Mon, 27 May 2024 07:27:05 +0200
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: Overlay Filesystem Documentation page
To: Amir Goldstein <amir73il@gmail.com>, =?UTF-8?Q?Edouard_Gaulu=C3=A9?=
 <edouard@e-gaulue.com>
Cc: neilb@suse.de, miklos@szeredi.hu,
 overlayfs <linux-unionfs@vger.kernel.org>
References: <a89eab01-6856-49dd-ba5a-942d58d8ebe5@e-gaulue.com>
 <CAOQ4uxjmfSksa7W88B2xq719RdZGGEqvY5OQzZuOMPCmRyG8Ag@mail.gmail.com>
 <9c0ea3be-9022-4b3c-b2ad-8e6e34486092@e-gaulue.com>
 <CAOQ4uxgXiFnvNV7av5dMoF8YS+JPrUM2L91pRXtdZ5gVA5=HFg@mail.gmail.com>
 <cd0a9c43-f3c9-353f-1fcd-f29009c2b8f7@e-gaulue.com>
 <CAOQ4uxjhuhz2=ve2vFydLEg5+-bLrFxDX0ufSf5fOF4wF_y-xQ@mail.gmail.com>
Content-Language: en-US
From: Vyacheslav Yurkov <uvv.mail@gmail.com>
In-Reply-To: <CAOQ4uxjhuhz2=ve2vFydLEg5+-bLrFxDX0ufSf5fOF4wF_y-xQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Hey everyone,
I'm inclined to agree with Amir here. The userspace tools can be 
improved / extended, but it's not the scope of the kernel documentation.

Vyacheslav

On 25.05.2024 09:32, Amir Goldstein wrote:
> On Thu, May 23, 2024 at 11:56 AM Edouard Gaulué <edouard@e-gaulue.com> wrote:
>> Thanks a lot Amir,
>>
>> Here is a proposal, but consider it as a draft:
>>
>> "
>>
>> Changes to the underlying filesystems while part of a mounted overlay filesystem are not supported. Thought Overlayfs will try to handle those changed files in a way it may not result in a crash or deadlock, you shouldn't do it. Due to multiple reasons involving caches, attributes, and others, if the underlying filesystem is changed, the behavior of the overlay gets "undefined", so you can't trust it anymore.
>>
>> Offline changes (i.e. when the overlay is not mounted) are allowed to the upper tree. But beware of remount after offline changes to the lower tree. They are almost supported if the “metacopy”, “index”, “xino” and “redirect_dir” features have not been used. If the lower tree is modified and any of these features has been used before on this overlay, the behavior can also get "undefined".
>>
> Edouard,
>
> I am sorry to be discouraging, but I personally don't see much value
> in this rephrasing
> and I also don't think that the current documentation is lacking in this point.
> This is my personal opinion and review is a community procedure.
> If there are proponents for this rewrite let them speak up.
>
>> "
>>
>> I came to overlayfs, because of chatGPT. It easily proposes to bind mount between upper and lower. Just say: "I want the feature of overlayfs, but for this specific directory, I want it to write on lower". The provided solution writes on the underlying filesystems (through bind), even if the result is quite predictable and almost works. Now I understand better the way overlayfs is working, I think there should be a warning in the documentation (that chatGPT or others may read next time) regarding this:
>>
> Overalyfs is not the only way to merge directories. This is out of scope.
>
>> "
>>
>> Overlayfs will never write on the lower filesystems, so it will never arm them. But mind the interactions you could create outside of overlayfs using tools like bind mounts, "rsync" or even "cp" between upper filesystem (or merged) and lower ones. Those lead to changes to the underlying filesystems and should be avoided as already stated.
>>
> Sorry. This feels out of scope to me.
> I think the introduction sections describe overlayfs and lower and
> upper layers well enough.
>
>> "
>>
>> Finally, I think it would be great to have an option to clean dirs of all previous xattrs set by overlayfs at mount time. Or a command line in the documentation to explain how to get the same. In the meanwhile, I would add:
>>
>> "
>>
>> Note: in those specific cases where data written to the overlay can be recreated without significant effort (like in volatile), you can always recreate an empty upperdir and workdir before remount.
>>
>> "
>>
>> But it doesn't handle the case of those who had bound upper and lower, and decide one day, to use the lower as an upper.
>>
> Sorry, but I am not sure if those details belong in the scope of this document,
> because I don't think we would like to commit to any specific procedure of
> cleaning the upper layer.
>
> I do hear your concerns as a user, but I don't think that better documentation
> alone is going to solve them.
>
> What overlayfs has always been missing is a counterpart library and user tools
> to deal with those things.
>
> There has been an attempt in the past to start overlayfs-progs [1] and later
> overlayfs-tool2 project [2] to work on offline overlayfs layers.
> I even contributed the "overlay deref" command [3] which partly does what
> you are looking for, but it does not look like this project is
> actively developed
> except for a recent merge of the fsck tool from overlayfs-progs.
>
> Thanks,
> Amir.
>
> [1] https://github.com/hisilicon/overlayfs-progs
> [2] https://github.com/kmxz/overlayfs-tools
> [3] https://github.com/kmxz/overlayfs-tools/pull/11

