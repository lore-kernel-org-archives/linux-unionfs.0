Received: from mail-wm1-f53.google.com (mail-wm1-f53.google.com [209.85.128.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE11630FF1E
	for <linux-unionfs@vger.kernel.org>; Mon, 18 May 2026 23:21:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.128.53
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779146475; cv=pass; b=Q65iKSPvxt7ATmIwQNQ7TFslqMeViM0vTRpktC8dghz9DpjKXBi8f3Kxtif/J7tJj70tXJ+aI0t/gQgrFl/97sMP6i62X7vz3X/849bF8rlp2n7RSCFV1A1cTzBa8PrfluJZbrtrSxcFhd7v4Ii+WMj1s61MLLs1mCw1Es9zFSA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779146475; c=relaxed/simple;
	bh=4x3zQNmL9iHk74lRp0E3/wEsCAyJKC8fWM1/7YYLjCA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Lx96LSv/jKZGWfzvaR99igJTrCg1YKNU0YTvnuPbgZnA6ClSFh/tC1iB5/SzhF3taH54Np5uvzV5reiku/zh1iP9rhO1VRkQ8IxQ1gCdX2XmraQtmAbeYyUIfw2tWjH4p2WstazYL6HMJ8zF+BVHgdjyr7GdKm4KU9qVqb1h4Ig=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=EzqekbVI; arc=pass smtp.client-ip=209.85.128.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="EzqekbVI"
Received: by mail-wm1-f53.google.com with SMTP id 5b1f17b1804b1-48d102471a4so23012115e9.2
        for <linux-unionfs@vger.kernel.org>; Mon, 18 May 2026 16:21:13 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1779146472; cv=none;
        d=google.com; s=arc-20240605;
        b=Vc1JSwaF/eooks6MVqOGTXndJ1PpQhNNpO2Ei1PaNqVsEZgvYZRTBgO60Qk30l/cYe
         mRXcL0Wc9PsaqYdmX6u46+IP5KHfN7uVVI5dckKLSk8JjkNnAI3JN+1N/ko+BKc4x+hE
         zK0zj6l5UGR5sX319Oz9T6rHJq+0fUOByNWT6BQwmk/o3axFah1N4UlHO65Ze0HVndTl
         0feM90A3iy7UIlI9nKBXDoXiDj1RAg0xgFSMQyVgW+9gV6T3++3nFAf0bet4IW3mXJcG
         ZfwuUQWy/kzGLRvfoslaUd8pyk4DUtCv1yiwf6+/bh/mEFvLoL8PTppLKhtNdISfNeUj
         IqKQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=qigLvnHqnvJ1q/CbxAtya5W8ES5fZ7EbWfFSlybCG8E=;
        fh=lmebBIqFuUjQ6U0zfdXALRuzA8ZUcX+iMY2Xg0Ng99U=;
        b=ZLvenPZ7Ns3pjDTbprPfejcYrvxqA/cajqj+TSPMqzJ6DoTSGEsD1Mppg5vTfk4Bvs
         MGxwjAi+FquUuxAIyvW6LuFcUHm39OVpHd1DypQrmZ6KQUWWUMOktj0DZzUbCoZxq2PD
         cNu/Xk0jxI61pObdnnwa6dPUluk08C9F8NMPyqp8vFt8Jkc8JcXZ4UbDDaWw8VJe2Y2v
         9GkB8CsC4Z86xHFb8jEfFUnI5jJyLH96P6CDIzHDVjXBsSVg2d1HsUsk4Ox0LBSD/Iw6
         fLO8yIu+U4uTflmMP7GGV1YLOfgq8OgIEqNTWG7kFFt+x1Cn6pq/3ARO8XOsAhaQddcn
         KdyQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1779146472; x=1779751272; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=qigLvnHqnvJ1q/CbxAtya5W8ES5fZ7EbWfFSlybCG8E=;
        b=EzqekbVIfvGNJ1HnX1BYgkBKpzeLn1yGwiUXMcTYz5tDE1LpiuTPU1N9+1WRq7AYr9
         KwKrFqJ8hgve3n1iF2khKhyGV5+D10XN3FXgR6tN4RdIjURlyca0BYDumz8CNLoBe2Ss
         wmEHLQ5EAWoBB1vifXKO1K2FxgAe23Pkw2n0kHSgJssNz2a+bzGtL1GthrLesDHvBKGd
         ycItoLl8/V21S95SLgfxEkjS26PtLxEUpvqYg0wxJnUIwdNh9kkTCYwJs3GFjIDQeIfE
         2Kkz/dALW8sNCgi+H+ZuWF0cmeEp0mtZ0J5nhbgium35NbIVE82OUEWQDTFtouTwDbAg
         52rg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779146472; x=1779751272;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=qigLvnHqnvJ1q/CbxAtya5W8ES5fZ7EbWfFSlybCG8E=;
        b=rzfG2DHU085wRX7kqNfqCbGay/MSAZsh1XZJzENq2i8gVCCRwc0cYobbr6/GCjE21A
         ci7/wOweey3XKcaOe6I7h2dqrmNi58vhtszLL4/xOQ4u9eJ+a5td7OjtbZPwsOaVTWey
         IZh6/V1yFca9BHfd1LADRJ/j1DKLRW1UsEfVfyPH4rN5kZ2x/Z+TR7IQ8EOAdrmibPfm
         ajJnBWBff75/t/fJHUHLC3sQRdKkiS33rIfdJrISFu8Y3JMRycasoz5q89uZfQPNxqZT
         jHGyXUGeGkeqxQEfGhkvuCLfJ8w8mIONFC6VGE0QgzmkJnCUJWrvZAMdfquuKDSSwkvl
         DLlw==
X-Forwarded-Encrypted: i=1; AFNElJ9AbvKiAezA3jVY3v4E6ExCFiydHsQCNB4pkXSI23ttRnE1KUjvJYRu1tufl4UfRVxzNCQXQph6cjEbbamo@vger.kernel.org
X-Gm-Message-State: AOJu0Yz+y7L7Ynyo2F0uANvPYaNgTa18X6PeOXEQhBM5PbrN3mrJuIp1
	KcZyOpfPDwjhRj2Ker2I41gBZcAbc92/b9inC2ugAKoNoXD1i6awWFvo9ASBwc/gOMd4FEDG4en
	ovNJF4hIOPb/xeJ7QhULUb9t4qcJbJI7nU+OT
X-Gm-Gg: Acq92OEfjz6cgksO/VIQYpkOmY3OsBrswh0jDsIBWDyPmuiQGoHilokmVWakLh8HCVm
	k9ET/C3/D9vOwEYnPWp2cO5CaDaQHA//WYX4xkQSyL2tffuzBwzwA8ZsPHFlgYpQ9Lc0JFsvXXp
	kQ+njz3eiy0fmN0yZZLjSpNM0/T4X99iALdLXzm3R4QE/KcqiPJT7ftnjVRvYMs1ydXbevgkbLM
	5L704t85m5GsUpkPbgQ9FigBPgi48WJxLUAUIGrfw3FQW6CvWfQ455JhRUz2b3IZbcwpgoVPLVT
	3jBKug==
X-Received: by 2002:a05:600c:a11c:b0:48a:5970:2003 with SMTP id
 5b1f17b1804b1-48fe5fd483amr203177845e9.3.1779146471937; Mon, 18 May 2026
 16:21:11 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260516004004.1455526-1-joannelkoong@gmail.com>
 <20260516004004.1455526-18-joannelkoong@gmail.com> <CAOQ4uxg9WT7WmJqQezgiCB1jOX_heW+=UJbbFntbfDUdm0H=tQ@mail.gmail.com>
In-Reply-To: <CAOQ4uxg9WT7WmJqQezgiCB1jOX_heW+=UJbbFntbfDUdm0H=tQ@mail.gmail.com>
From: Joanne Koong <joannelkoong@gmail.com>
Date: Mon, 18 May 2026 16:21:00 -0700
X-Gm-Features: AVHnY4Ij6E14B25Js9mPctacU2JwfQZGAV8QNpi-IPpjZfOoDi-Gn3aZptVLHLo
Message-ID: <CAJnrk1bqfAczXnTxtb_rui2adksDpFKXOvJyj=zotGeWJoA5sw@mail.gmail.com>
Subject: Re: [PATCH v2 17/21] backing-inode: add backing_inode_copyattr()
To: Amir Goldstein <amir73il@gmail.com>
Cc: miklos@szeredi.hu, fuse-devel@lists.linux.dev, 
	linux-unionfs@vger.kernel.org, Christian Brauner <brauner@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, May 16, 2026 at 2:33=E2=80=AFPM Amir Goldstein <amir73il@gmail.com>=
 wrote:
>
> On Sat, May 16, 2026 at 2:53=E2=80=AFAM Joanne Koong <joannelkoong@gmail.=
com> wrote:
> >
> > Move logic in ovl_copyattr() to a generic backing_inode_copyattr()
> > function in a new fs/backing-inode.c, which other filesystems that use
> > backing inodes (eg fuse passthrough) will use.
> >
> > Signed-off-by: Joanne Koong <joannelkoong@gmail.com>
> > ---
> >  fs/Makefile                   |  2 +-
> >  fs/backing-inode.c            | 43 +++++++++++++++++++++++++++++++++++
> >  fs/overlayfs/util.c           | 33 +++------------------------
> >  include/linux/backing-inode.h | 14 ++++++++++++
>
>
> Nice!
>
> Please add these files to
> FILESYSTEMS [STACKABLE]
> section in MAINTAINERS.
>
> Otherwise, feel free to add:
> Reviewed-by: Amir Goldstein <amir73il@gmail.com>
>
> There is one more cleanup patch required, now or later, to get rid of
> some awkwardness in kernel fs code.
> If you don't want to deal with it, I can take this cleanup later.
>
> d_backing_inode() is a noop from the day it was added and has 177
> call sites. Those call sites should be converted to d_inode() and
> d_backing_inode() should go away.
>
> backing_inode_security{,_novalidate}() are likewise unneeded
> dups of inode_security{,_novalidate}() and should be removed.

Awesome! I'm happy to remove these.

You mentioned in v1 that fs/stack.c and the corresponding
include/linux/fs_stack.h are pretty much only used by ecryptfs. It
looks like there are only two pretty minimal functions in there. Do
you think it's also worth moving that logic into ecryptfs and
eliminating fs stack?

Thanks,
Joanne
>
> Thanks,
> Amir.
