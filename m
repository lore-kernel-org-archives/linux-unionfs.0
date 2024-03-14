Received: from mail-ej1-f41.google.com (mail-ej1-f41.google.com [209.85.218.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 179136CDAB
	for <linux-unionfs@vger.kernel.org>; Thu, 14 Mar 2024 09:27:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710408447; cv=none; b=U1D82gPs02UWiKZaRscUSaqXcBKrmkWyupXh4DaRVM8Q60acB7EgN05LCQuwteaM5Dc5Q+NefLHqInvBLNew/sZY/NzIQozxs1f05IJUo54grOYE/4ubpP58C7OfwZllimDsvrqYfvjFwP8/VvQA7WnSHR4ERfOmIPFbK8ksvvc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710408447; c=relaxed/simple;
	bh=OBMOgQm2JqMMB2lopZ6dLV4hKACv0lHz0FcYOf1y1Ps=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=i0jV+KP0AU0QhCYO8GOCk+fTduJNcvS6+m7urPkTYNdBRp8lPFXo2Fpan9S3lnNoBSKV/IRlqZL4hxw1N7vt7U6nJSscdsdhQkgYsS91K4AqujyU/umLiYGA8ESgmzXChjqnCkGOFe0bnY8hgpfNPvw57FoPyFQpvK0NRsQo/G4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=szeredi.hu; spf=pass smtp.mailfrom=szeredi.hu; dkim=pass (1024-bit key) header.d=szeredi.hu header.i=@szeredi.hu header.b=ZSEWrNwG; arc=none smtp.client-ip=209.85.218.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=szeredi.hu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=szeredi.hu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=szeredi.hu header.i=@szeredi.hu header.b="ZSEWrNwG"
Received: by mail-ej1-f41.google.com with SMTP id a640c23a62f3a-a466a256726so135947066b.1
        for <linux-unionfs@vger.kernel.org>; Thu, 14 Mar 2024 02:27:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=szeredi.hu; s=google; t=1710408443; x=1711013243; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=jwIUIDarsV7ESSt3w5nAJOv8KAEl9jUo5NAlBXlY4TA=;
        b=ZSEWrNwGmkqgI2bPfXNWp2ba5/6qhjPW2oShv6cHkGPqRcgyiRI3OLluJLNslTPE8m
         QZLaFfdsqwBv5FknIywyNq9p7Uc7jfn+t+YysGxVUec5LkIqq1ZdsjIZgKI/6ZHuTBw1
         1CsfKJayEI4aP4g+LvSOOt3IeAPdISFJLokLc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710408443; x=1711013243;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=jwIUIDarsV7ESSt3w5nAJOv8KAEl9jUo5NAlBXlY4TA=;
        b=X4AsGBf2jXZuvWa5KBiVNYUI8Rz1THR0I3HzE4xYMzOTFf/Cp02g4bBqThsQbIuc5X
         mODkFMoDZ6UGBMVN0TaKPKSFuTp8v9wHOuvQuSOhSjQx/r3d2GeNdf9i4UzFyx3DAAeK
         22RHuw+BAsN6zBb0IQWA81MmltgS/lS3XHB4GWppWd0kExh8zhZwXUdL+g2mupxbLRbu
         89Eyw7K4c7s3jRnymbCIRzSo0fcBEfq3pM6owcC01FLQ++3Mn0432RrknV6nPZrsAnLy
         4maJydM2AKB5irc1sf3Na3h+jPrOkGf2TtwUm9itZoH5z6rW1FrKmUF8g/YgEQ1Bx85v
         Inwg==
X-Forwarded-Encrypted: i=1; AJvYcCUcX0i3tWHdZff/zcUpo7FLWS3A0nBTL+psWJ7r1+jlA9tuyC1PB48VU0tpBIzYNh5M6Sh63017+Qt4cuyh4GND4gdUrU/mBjnqNaY12g==
X-Gm-Message-State: AOJu0Yz+nDOjpMTM8seKWo0puf2HvSChm0bwao87/peC29msc/aIxv8O
	RcE59ATwMYnQ2gADEtwR7+/6pJfsrFDBQXvR2Fwas1mlGCUNXSc/PTlGl1ABLXc236kF26P5nfk
	dosNcAdTUyqZrvkjaqzOvXFdguX8KUrt3swJGaw==
X-Google-Smtp-Source: AGHT+IG9tD8CTtuCAlV6cIOBe248EyyGlWLXTZiDIe13U6BkGzprg3jxR3h7gCKqYLgyibmLVEujy2gDWnOYr+xGuvU=
X-Received: by 2002:a17:906:fe44:b0:a3e:4d7c:9ce1 with SMTP id
 wz4-20020a170906fe4400b00a3e4d7c9ce1mr1156151ejb.21.1710408443295; Thu, 14
 Mar 2024 02:27:23 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <000000000000bb26fd061392e1a9@google.com>
In-Reply-To: <000000000000bb26fd061392e1a9@google.com>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Thu, 14 Mar 2024 10:27:11 +0100
Message-ID: <CAJfpegs9LQqzMLPc7Urw15sj9bHUmMe1CES6iPADrF-YP-_amg@mail.gmail.com>
Subject: Re: [syzbot] [overlayfs?] possible deadlock in iter_file_splice_write (3)
To: syzbot <syzbot+e525d9be15a106e48379@syzkaller.appspotmail.com>
Cc: amir73il@gmail.com, linux-fsdevel@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-unionfs@vger.kernel.org, 
	syzkaller-bugs@googlegroups.com, "Rafael J. Wysocki" <rafael@kernel.org>
Content-Type: text/plain; charset="UTF-8"

On Thu, 14 Mar 2024 at 00:10, syzbot
<syzbot+e525d9be15a106e48379@syzkaller.appspotmail.com> wrote:

> -> #3 (&ovl_i_mutex_dir_key[depth]){++++}-{3:3}:
>        lock_acquire+0x1e3/0x530 kernel/locking/lockdep.c:5754
>        down_read+0xb1/0xa40 kernel/locking/rwsem.c:1526
>        inode_lock_shared include/linux/fs.h:814 [inline]
>        lookup_slow+0x45/0x70 fs/namei.c:1709
>        walk_component+0x2e1/0x410 fs/namei.c:2005
>        lookup_last fs/namei.c:2462 [inline]
>        path_lookupat+0x16f/0x450 fs/namei.c:2486
>        filename_lookup+0x255/0x610 fs/namei.c:2515
>        kern_path+0x35/0x50 fs/namei.c:2623

This is what ultimately closes the locking loop: doing path lookup
(taking directory i_mutex) with kernfs of->mutex held.

#syz dup possible deadlock in seq_read_iter (3)

Thanks,
Miklos
