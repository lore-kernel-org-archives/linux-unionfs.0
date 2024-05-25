Received: from mail-qk1-f182.google.com (mail-qk1-f182.google.com [209.85.222.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B3A320ED
	for <linux-unionfs@vger.kernel.org>; Sat, 25 May 2024 07:32:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716622342; cv=none; b=skrFe4fjMBe/4F2bUmFzfnvMdInsdbQ8o82BYyezTR0MOnpwPNzXlNXT9EDJMlP/KWzw8xbngKfCYgEjxw4te/kOE8m9u4Jl4lp7X8rrcwFITKYYeLIi/zDUjrT6FB9nuubERFa2go9CvsSqwdcoCMs5bG7xuXsIhw8AkSrAnaM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716622342; c=relaxed/simple;
	bh=HquhLPACd4gVRkEHk4yrgjcIJV3JOtmyF87GeWT+Pa0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=lP1rHDUpNymStYquK9GwPVEeU5dEr83EfCIJXZrCGoyQRkTjtcH3qtOEIHnlIC+woTvkejcMu91rbYH6tDjKE407zOWn/JrCOLsvozyOk6ZxOsVoT3Pgj/YGNXeOJSwBTQhdrq8AXGNe4/JodcYRl57yf0zeDKWGrQcL98HcRlc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=bWCwa925; arc=none smtp.client-ip=209.85.222.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="bWCwa925"
Received: by mail-qk1-f182.google.com with SMTP id af79cd13be357-794ab4480beso120311785a.1
        for <linux-unionfs@vger.kernel.org>; Sat, 25 May 2024 00:32:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1716622340; x=1717227140; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=HquhLPACd4gVRkEHk4yrgjcIJV3JOtmyF87GeWT+Pa0=;
        b=bWCwa925ucevN2QTiVBZsXLCQcmRU5mlQtP+nKoETZ04tteizK6nKbQbcm/AYnOh8u
         4ZiZlfVn/F1TarV3Kyz9uVkbqvpMBM+otNxNLCEjrF3ECXKbStDvoB/mpk43nLX0o21O
         y+SXQrX1+m8uTYrmcYBBf6crNmuiRw2ZysCAPxXFQgrI2cA3FJA/z+7/DE9JGBlYMazk
         2+iNjGJ8HDfn28VVsl/B0vPS8QpXb3batN74KKJ8obj5ZV/5Fv1W7IDt+23uTOEhhJEm
         55WcrLWYL+T9wlt9tkIo/GauHf4OCdUmU/yP9PzNbJ5j85JF4HJO84tvup1fHu/HAbcC
         vWLA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1716622340; x=1717227140;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=HquhLPACd4gVRkEHk4yrgjcIJV3JOtmyF87GeWT+Pa0=;
        b=Am/+8jKRC2wlsLKz061WBTfKgVyFJ04hiTzIlM8dcGv7IpilOirZyEdCOFzZa2wS2M
         YD+O/PXJwbOYgRibI4PmVkzs+/5D2MkfSH6l2qfvD2dNzaCang8ivOBUzoCs8L1SlGEL
         Qpi3qN2ncjZhUiydqCsKq+NSznSlWjjf815RwAxddNv7cuMB91m7R/88d9hXa+KgSb2j
         v/lhjmUBkwAhUO83C8ElcNxD0cfA+doSG2hBX4//+8XlvyXEpJUZd0aqNIbWQWf4qf6o
         OOTIl0dcDiNY6at7oTHdzClb2kLrpFwfMF9+UkQKkfltqhY3ei30y9RCao9NOkVw4whi
         DKTQ==
X-Forwarded-Encrypted: i=1; AJvYcCUkwCTyg0RKo+JnQJUgIr5701YLtW07m8DiYYzGY8c41teojHRrCW/oMsplNzbpqFOsrl0UV9JnNgmDJ9fTQssgjoaVJR6sg9jFES+kAQ==
X-Gm-Message-State: AOJu0Yztz8CbraU9eOHneXep1Bw4BEUHwC/A5FsVbK26Vo6uA8G8+dvl
	zimc7yApLA+qIDcW18E/gmkedYoHMriZbF26Dck3G04x2P+/HqYioCxRZ3NucTQasVf4Po2zfcw
	iUYyDZZHQC1LVB7wgvzLFCPrHKWQ=
X-Google-Smtp-Source: AGHT+IHqLY/bZHqjAMTXmpNsdOJYFTb2Vl1UXRYQ0GqAqUTs3t7M7NGHKw6mgbsPRi/WWdaoRkv92uAbWJ8Hl+FQ/ec=
X-Received: by 2002:a05:620a:1197:b0:794:a84f:9ef2 with SMTP id
 af79cd13be357-794ab07bcabmr486408585a.23.1716622339881; Sat, 25 May 2024
 00:32:19 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <a89eab01-6856-49dd-ba5a-942d58d8ebe5@e-gaulue.com>
 <CAOQ4uxjmfSksa7W88B2xq719RdZGGEqvY5OQzZuOMPCmRyG8Ag@mail.gmail.com>
 <9c0ea3be-9022-4b3c-b2ad-8e6e34486092@e-gaulue.com> <CAOQ4uxgXiFnvNV7av5dMoF8YS+JPrUM2L91pRXtdZ5gVA5=HFg@mail.gmail.com>
 <cd0a9c43-f3c9-353f-1fcd-f29009c2b8f7@e-gaulue.com>
In-Reply-To: <cd0a9c43-f3c9-353f-1fcd-f29009c2b8f7@e-gaulue.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Sat, 25 May 2024 10:32:08 +0300
Message-ID: <CAOQ4uxjhuhz2=ve2vFydLEg5+-bLrFxDX0ufSf5fOF4wF_y-xQ@mail.gmail.com>
Subject: Re: Overlay Filesystem Documentation page
To: =?UTF-8?Q?Edouard_Gaulu=C3=A9?= <edouard@e-gaulue.com>
Cc: neilb@suse.de, miklos@szeredi.hu, 
	overlayfs <linux-unionfs@vger.kernel.org>, Vyacheslav Yurkov <uvv.mail@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, May 23, 2024 at 11:56=E2=80=AFAM Edouard Gaulu=C3=A9 <edouard@e-gau=
lue.com> wrote:
>
> Thanks a lot Amir,
>
> Here is a proposal, but consider it as a draft:
>
> "
>
> Changes to the underlying filesystems while part of a mounted overlay fil=
esystem are not supported. Thought Overlayfs will try to handle those chang=
ed files in a way it may not result in a crash or deadlock, you shouldn't d=
o it. Due to multiple reasons involving caches, attributes, and others, if =
the underlying filesystem is changed, the behavior of the overlay gets "und=
efined", so you can't trust it anymore.
>
> Offline changes (i.e. when the overlay is not mounted) are allowed to the=
 upper tree. But beware of remount after offline changes to the lower tree.=
 They are almost supported if the =E2=80=9Cmetacopy=E2=80=9D, =E2=80=9Cinde=
x=E2=80=9D, =E2=80=9Cxino=E2=80=9D and =E2=80=9Credirect_dir=E2=80=9D featu=
res have not been used. If the lower tree is modified and any of these feat=
ures has been used before on this overlay, the behavior can also get "undef=
ined".
>

Edouard,

I am sorry to be discouraging, but I personally don't see much value
in this rephrasing
and I also don't think that the current documentation is lacking in this po=
int.
This is my personal opinion and review is a community procedure.
If there are proponents for this rewrite let them speak up.

> "
>
> I came to overlayfs, because of chatGPT. It easily proposes to bind mount=
 between upper and lower. Just say: "I want the feature of overlayfs, but f=
or this specific directory, I want it to write on lower". The provided solu=
tion writes on the underlying filesystems (through bind), even if the resul=
t is quite predictable and almost works. Now I understand better the way ov=
erlayfs is working, I think there should be a warning in the documentation =
(that chatGPT or others may read next time) regarding this:
>

Overalyfs is not the only way to merge directories. This is out of scope.

> "
>
> Overlayfs will never write on the lower filesystems, so it will never arm=
 them. But mind the interactions you could create outside of overlayfs usin=
g tools like bind mounts, "rsync" or even "cp" between upper filesystem (or=
 merged) and lower ones. Those lead to changes to the underlying filesystem=
s and should be avoided as already stated.
>

Sorry. This feels out of scope to me.
I think the introduction sections describe overlayfs and lower and
upper layers well enough.

> "
>
> Finally, I think it would be great to have an option to clean dirs of all=
 previous xattrs set by overlayfs at mount time. Or a command line in the d=
ocumentation to explain how to get the same. In the meanwhile, I would add:
>
> "
>
> Note: in those specific cases where data written to the overlay can be re=
created without significant effort (like in volatile), you can always recre=
ate an empty upperdir and workdir before remount.
>
> "
>
> But it doesn't handle the case of those who had bound upper and lower, an=
d decide one day, to use the lower as an upper.
>

Sorry, but I am not sure if those details belong in the scope of this docum=
ent,
because I don't think we would like to commit to any specific procedure of
cleaning the upper layer.

I do hear your concerns as a user, but I don't think that better documentat=
ion
alone is going to solve them.

What overlayfs has always been missing is a counterpart library and user to=
ols
to deal with those things.

There has been an attempt in the past to start overlayfs-progs [1] and late=
r
overlayfs-tool2 project [2] to work on offline overlayfs layers.
I even contributed the "overlay deref" command [3] which partly does what
you are looking for, but it does not look like this project is
actively developed
except for a recent merge of the fsck tool from overlayfs-progs.

Thanks,
Amir.

[1] https://github.com/hisilicon/overlayfs-progs
[2] https://github.com/kmxz/overlayfs-tools
[3] https://github.com/kmxz/overlayfs-tools/pull/11
