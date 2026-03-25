Received: from mail-ej1-f49.google.com (mail-ej1-f49.google.com [209.85.218.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6254D19995E
	for <linux-unionfs@vger.kernel.org>; Wed, 25 Mar 2026 12:03:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.218.49
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774440229; cv=pass; b=NA5he3haqvevWgtz9Z40nzUIoJ4xps2LkCNfs48EZeu3U5JmXlHotajd7xL2YTYYbWbTQLbbF4u8E5I+zWUIRIE8z30nIcQdO5jL4p1eLNSJrbXwCAc1Z0xTE7hS0uLK0rJwX2MBWO/Gl9Z38wreBr3tQQIiNcT76WdlAnesang=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774440229; c=relaxed/simple;
	bh=vb7uvMgj+8pqSx85DvCgOQ/cEcgsqLMGegmZ1K2OngY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=i5TgjClvi/pvELrZKkfvwc20lk0GtgD4LSRth2bKV/vdSoCjRiOyL3TI8WjZ+xtXzCi0S1xZa5HJcBs2tkfIpV+2J5kAs8JMzcqeFUbNMIbmlWmtozKroXUuPd3qhl6S0S1P4JxNI17b4rUOCMDOjBeQ2DJ2tCNG2HMNBvDuuXI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=QQYTgU3o; arc=pass smtp.client-ip=209.85.218.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="QQYTgU3o"
Received: by mail-ej1-f49.google.com with SMTP id a640c23a62f3a-b98133bdc4bso816983866b.0
        for <linux-unionfs@vger.kernel.org>; Wed, 25 Mar 2026 05:03:47 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1774440226; cv=none;
        d=google.com; s=arc-20240605;
        b=IC54ALbpz3X7bMd5CPpVdUuyn7Xqyf1HFC4LbEZEDYpqqKKLCbuGDYbD3s3mdFQW6N
         Z0SKqV+puMDo6rdeZYKJg2n2JEvkQ77APIs2TRcBRir4dKB9u2Q9TpjInzdlP1Dk179i
         xhhbl8tBrYSrN0SDL4BNyVnQ9YEwyRVGJbRcRT7Mw1RL2nlJK1Rt8josyayyxhj1nuqe
         /jQxqc9x06s+X/ZyWrS+DmrMlSgExtVPwRBPSFbYvblMZ1Y8wQ9/2sUMjrQPXPPq+AiU
         prgGM/dYdMOZJEF3CpyKQlLVW2wz9lWCCobwkjoWBbCgwvW5K8rw0ZIO0aVPIwmMAj+E
         zj6Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=vb7uvMgj+8pqSx85DvCgOQ/cEcgsqLMGegmZ1K2OngY=;
        fh=inkIdNJmXEGrGMLbHaPZPdE6Y23IOamd6uUBrFFBFAk=;
        b=CId6n3UxzAnFUFCsfGEm4WQLz1M+nulS4C9QVEVc/dC85jxsygbRFAXln9NAJ6LEA+
         SfBuqz0GNvQwpzgz8zfWJ3B0o645RICk+O+Z8LXdMcXaT27TlJ9+OAzAXO/OKet2sPA6
         IdsKN5rsniPW+1Po4ZPPXu/BDD1dLIllWD9meGriebMjRVBMI6/pkpi22HwceQcp9QFg
         D4ymJGgMqk3TbhxHv/kHN6B+RlYTiWrke4ghDprcLNEyCdfzJzxl2yjk8M2SBIAWPDut
         faYTOfrtdFns9+do6Rl2HRnH78AKREnHXvtRx+nCRVbBTmm1XopoPnXhHuuWguTaMyy6
         P+Pw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1774440226; x=1775045026; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=vb7uvMgj+8pqSx85DvCgOQ/cEcgsqLMGegmZ1K2OngY=;
        b=QQYTgU3oqQkkuA3YhoETSzobfKrhfbQutworh0GWHJzNSUEQp4IIw8hk1RnWf/sWY/
         jFpSW502ikRTJW0UXmYbQtp3hH08zM+qsk0pLGfDPnxUY+c8Xo+6DsssuGnJZXlN6nQL
         XEeg+fXMsug+TQx6DcAbHqL9VNYMpfW+7qT4oj+Er60ErVHnJ0wb5hvsMwv24cewZGP7
         oPLLJTAZ3JscWgATaEzi/hBTuZdYTdFH9cOYqT8D/f1DvQZiGKNzTxs3Mh7QTNPsRbQk
         KxDQPF9J88sleBn0kW34Z6DYf4LH3pZMtrgAkZW5N7FWsJh9afPjZhnT0oWLonhph9th
         IESA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774440226; x=1775045026;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=vb7uvMgj+8pqSx85DvCgOQ/cEcgsqLMGegmZ1K2OngY=;
        b=TqysuDTqJQYC6fo7Yi/7lhB+5zf3UrZ3rmvh5LooGTLvgRrCY8EU/uZvh17V0BcNsi
         JMArrfJFpoQjKXzBWhWWNND9oKb+jgtUhEXzyGZVungILYyBRwOEBl9vGR1tCvnQXnHY
         JQ+/A5CSJwNdMchbeiGOuvYkqa3/qBmvXCTrE9Nmia9iZtkOZgJLOffEgj56caXelVr6
         AhsoK6mEhxLr93hhjFhjkuCCTKgy5zy4nLaBVGaq20ed1mJ2ynIU3P7+sbAz2/qhWtBS
         jbTq/z68vjmMEiW6AolSNkJNha9rSUPHUqP99nX39jpgkEVjvuUvpg0R5kFbVxrveHu8
         a6TQ==
X-Forwarded-Encrypted: i=1; AJvYcCUdo2j1ASpZ1qiQKbv6M5C4QL8N584+Q9aLbKx+Gm6T9oHMqX1SX97IJNlb3fzuo8eFd5gCBi6pla/RPibj@vger.kernel.org
X-Gm-Message-State: AOJu0YzRtoeC1q+Zk0FdIIcIZQjZtRqiy1lv5+tTh2uf9QTtAv0MozJe
	OHm5jhukqltH+3lPYvV++zHssMXS6HJwvjf3OhtkUiGIiZ0Wu8EqlYfp5KEyUftC1PgF1vt8kMy
	7LOB5POBM4GT0pQFtFvBJpLagrLu8NrE=
X-Gm-Gg: ATEYQzz0Srq7oS7ueSZHr3yJqyWRJ38YR7MovucbNHuY800i2BDIrUNUlN7db8WN0lN
	qklr/VzQ20Dv1szU3pmbFQCY6AMlgZNDmhC0Xhqyq2MPDrcKDKed+9JnT86LQrll0PW7ISGI4xK
	d9WG+wuWYWZf1MMH4l205/5AnPWHWipkkS6m4s7Gf58+agQwzXvDxnHI31v/m5v5QKyiyuFuwAI
	AsyeIPrQwB6IGLSCCTa6rtq/ulpXCjrDat4vkA6SL41T1LWK+O3ihCONXMu+51gsriktc5P33wD
	04IFsUW7F8iGaRoBZTLzAFnBOksm8d1Q+cnef5EvEg==
X-Received: by 2002:a17:907:980e:b0:b8e:796a:fd5c with SMTP id
 a640c23a62f3a-b9a5425bcafmr230697766b.27.1774440226200; Wed, 25 Mar 2026
 05:03:46 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260324145750.90719-1-amir73il@gmail.com> <acN457svKhT5TcKI@infradead.org>
In-Reply-To: <acN457svKhT5TcKI@infradead.org>
From: Amir Goldstein <amir73il@gmail.com>
Date: Wed, 25 Mar 2026 13:03:34 +0100
X-Gm-Features: AQROBzAGy3XNT_kv4MdESc7yjI0imOrkuxyj3QWBiKFezafRk0eZnnUgjwE_k90
Message-ID: <CAOQ4uxh5NFvXGop6ne-zfRbH5p6BPT2kCt7dUkP__-TtpeJjJQ@mail.gmail.com>
Subject: Re: [PATCH] ovl: make fsync after metadata copy-up opt-in mount option
To: Christoph Hellwig <hch@infradead.org>
Cc: Miklos Szeredi <miklos@szeredi.hu>, Christian Brauner <brauner@kernel.org>, linux-fsdevel@vger.kernel.org, 
	linux-unionfs@vger.kernel.org, Fei Lv <feilv@asrmicro.com>, 
	Chenglong Tang <chenglongtang@google.com>, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Mar 25, 2026 at 6:55=E2=80=AFAM Christoph Hellwig <hch@infradead.or=
g> wrote:
>
> On Tue, Mar 24, 2026 at 03:57:50PM +0100, Amir Goldstein wrote:
> > From: Fei Lv <feilv@asrmicro.com>
> >
> > Commit 7d6899fb69d25 ("ovl: fsync after metadata copy-up") was done to
> > fix durability of overlayfs copy up on an upper filesystem which does
> > not enforce ordering on storing of metadata changes (e.g. ubifs).
>
> I'm trying to understand this previous commit more than this one,
> but what 'enforce ordering on storing of metadata changes' does
> overlayfs encode right now?

On copy up or a directory:
1. create a directory in tmpdir
2. copy attributes and xattr from lower directory to this staged
directory copy up
3. move it into place in overlayfs upperdir

Until commit 7d6899fb69d25, there was no fsync before step 2 to 3.
Only when copying a regular file there was fsync after data copy up.

This of course provides no guarantee over the state of the copied up dir
after crash, whether the directory is observed in upperdir with or without
the attributes, but in reality this is how it is since 2014 and for many lo=
cal
filesystems (e.g. xfs), there is little risk in this practice.

It should be noted that overlayfs is quite picky about which filesystems
are allowed as upper filesystems and specifically network filesystems
are not allowed.

> There is no real ordering requirements
> anywhere in the Linux file system API, so it does sounds like ovl
> is making some assumptions by default?

Correct. I would say "making assumptions" I would just say that
overlayfs has never taken this aspect into account.

> Are those documented somewhere?

I guess not, but now that this commit introduces, fsync=3Dordered,strict
and a documentation section about them, it is a good opportunity
to expand on this point. I will add that.

Thanks for pointing this out.

Amir.
