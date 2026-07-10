Received: from mail-qt1-f180.google.com (mail-qt1-f180.google.com [209.85.160.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7548E379964
	for <linux-unionfs@vger.kernel.org>; Fri, 10 Jul 2026 18:23:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.160.180
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783707836; cv=pass; b=SVf2ueZHY/sisXLsmR0TF31KifYgrWlqqyolmcbwkvqnJfVjR68w04c/fPRrzIquwinVQUqYgPoCbMKpLBwLfWWT8QgV2dr7FX/h3I4Jgtif9UhejBztgIQ9eO//3R7SW/qwAyJl3tars1v/ESa7XTXUMEqtN+rvAuzN8P/nVH0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783707836; c=relaxed/simple;
	bh=NxfR+RtpV98Uyvh4Vv0TesUuCBi39GQnAHBSA0RW5do=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Mr4oHTb2KGfF1U/PWKyRfCV+K0ZVcV4kg5tzuAO32foZcLLED2ssznZh6nhFUUcH+ps5wX0qHyh7NJgPgdN7GoXYWKhhuMrkO7KrSW699ZHM3LT4wtALh1hk7ulOHfG8nk7y1inE9JPAstqcb+9aG1sgv6fWMI1MSXwhj+oykWc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=szeredi.hu; spf=pass smtp.mailfrom=szeredi.hu; dkim=pass (1024-bit key) header.d=szeredi.hu header.i=@szeredi.hu header.b=jzunzhlv; arc=pass smtp.client-ip=209.85.160.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=szeredi.hu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=szeredi.hu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=szeredi.hu header.i=@szeredi.hu header.b="jzunzhlv"
Received: by mail-qt1-f180.google.com with SMTP id d75a77b69052e-51c21495722so5967961cf.3
        for <linux-unionfs@vger.kernel.org>; Fri, 10 Jul 2026 11:23:53 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1783707832; cv=none;
        d=google.com; s=arc-20260327;
        b=IwVmv14e6eKrprZTi+muiHqQljmyAr7L3ssBtpk60ltbG0ENgPcAY/6XKV+sc1uT5m
         IArasyOQwdmKzBWeHctF9aNC11yN8oGm2GCkrogyqyT/PxaSAaSq2EhUjxW+ZLdU1gBX
         dVtFOJ0QRw2NcKVwYio1BuAl44Zc4t912OnxJ6htUyJdabrVKpLguxAf2mjkAMOUozF7
         JSFIWBrope7Zm7yFcz5q7JRyW9hyEJtZ/63c46D2oePsItiH4ol2jge2Fux2OrEEEhkz
         Ws9gA96wQkrOdlAe0atfPijfcqV2ovg+B/7Bb6L/NW9Fjp/oC0SSfucYSzcntG5nCqxP
         2BNg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=1S5jxvfvOLQgAIm7INh0Q2705ObnY2r648KNCWkCwDU=;
        fh=MmVnwYrOwK2I7/sJegqdp2KNYFO8sOZJXe7kWKiVN84=;
        b=FaGb/Ek2+6+irjTMjHxR+fbYeCuMZuf2qKtbcHmOOkW5mM4xb9rS/cxJ4g5pjjh4lk
         WQw0lZmSSw1l0WpT6jRenX6fAVSv5TY1byMcUVGoJHv1lf6f7dNCW3MeO6wlvfudFV3I
         IHxEOKSvvNVrUCB+E9yfWWaY2KJG3B2UvzFM3m30G+a+atSxF/6F4WHNOTGdCpWNrvuu
         5UnDQwge9mSrwSGanu3soxxHVpe6S4sSw3nxyAn7yIQUt9hPznhe6yKdhuivOF7w+HvT
         YUvYl9uszF+A+9zcyKUKOAAwjWfoXtE5pNjkSboNBkgoRNmAg5O5ojWjATCmLohHjS+U
         NI9g==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=szeredi.hu; s=google; t=1783707832; x=1784312632; darn=vger.kernel.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=1S5jxvfvOLQgAIm7INh0Q2705ObnY2r648KNCWkCwDU=;
        b=jzunzhlvhlauPfXky5Vl0XPvVolaBKFTOI+oS3/Ejz/Vo7GucK4CmuCXLzU9sjaaMR
         Uzds8vpJ3Hz9FmrKU8I3CjME5irVHg9jCs5bu87TWQ29lrdNCfqsigs/bjRY0PyspUKv
         U1oBuVdh9Qpl2aVfP12b2/yBFVQYEpdPE/FXU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783707832; x=1784312632;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=1S5jxvfvOLQgAIm7INh0Q2705ObnY2r648KNCWkCwDU=;
        b=eUeavHq0ZjaihEaBKbSU2f99G/bHjVUfwPnVo3CgJcwFGieHml2QulgGcGjMTB422B
         1zh/QB/KwdH3t1o5uLXxeSchz4ih262jNI2ar/GvILv1rsbf6arI3tk3pk8gPewlxd8K
         pw70/D3v1LbJoMNpOVKACY2CIJnzjgyMdSBGQv9jKfR26VMD2z/dSRipTXFbJClV2Sv5
         QwSC4tdYhFntl8tq6BUc6hl9fGg0LlJefTU6JBNQbrkP6hrMMH/LF4Lhx//tsiM2DihN
         ahN7MNLhS7k7o3aVWspdoWnwLkmSF1mYdm7tGyEd7CxPCx2tHIrNoA1S28Dn9la87CHu
         G8oQ==
X-Forwarded-Encrypted: i=1; AHgh+RpTxquiVvzxb6VaeVX8W9dfHTgNS5Kh9mzjz6MLyOTHG/GcxRtJ1lC56mArrdPfqqTti9EA3xOhVpR0LDlY@vger.kernel.org
X-Gm-Message-State: AOJu0YyMj0IFI69Ks8uUEDx2hOhn+8UbbM9BOKExwOzXcaEfuKV3QQlg
	5vKzTBAlm/9lW8m/BL5nbsebt4fpiAU8jFvqV6W6sxTig2AAXT/1wD2gg69BooWcHyryUfV+zXW
	1mhAYcapda/4JP7bFewIZ97/0yIf0hZmHM2cNbN+j3Q==
X-Gm-Gg: AfdE7cnZnqn/mYLryq1zAgAIB7pABSJYcRcqtjnlYGdI0VGni3XPTYTsSPaqjcxgEBU
	FtimWTOozMes6w7TSibaA53v/sWiD0bTRP8mHX881EiKah1D9LTeEK4CqifzcjLSn7jMJiA+Ns9
	Qm5LgSsLy0x1n+lXn/8nfseMULDSnJ0GgJ3MoCFf9ZoBw4rI25+9v+Cp4NU1ColdhK1/JTQ51Tg
	psGmJlj9EFl1ztnRLY11F5zxmzkDE6LuN0sUXt0/sGzaM1HNFuwAh+Vpl7Ocg2heKZZW7DIL/sI
	Fl8eyjpl+9bOA4P9Qn/nr57t7AIBlOyl2anwxw==
X-Received: by 2002:a05:622a:5a05:b0:51c:14f5:8f9c with SMTP id
 d75a77b69052e-51cbf15ff18mr692361cf.27.1783707832090; Fri, 10 Jul 2026
 11:23:52 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260708095831.3381978-1-gscrivan@redhat.com> <CAJfpegsJON=1_84PCGMjASYPFL=Wqsz7dnTAbO3Tdz5DfRQU+g@mail.gmail.com>
 <878q7l8y4y.fsf@redhat.com> <CAJfpegvQ06=2E0V_ADgxwmo7e5weTfOMozmBB-QVNLLWYAm8WQ@mail.gmail.com>
 <87wlv57dt1.fsf@redhat.com> <CAJfpegtTixwWSh9M-9NbwP0nUbJJ9rh0rxqO7BzgK7Su_RpM+A@mail.gmail.com>
 <87o6gh79yi.fsf@redhat.com> <CAJfpegvUEEbFnCa1N9k3gMXpw46YFpWuta=G6brON1=xU36bgw@mail.gmail.com>
 <CAOQ4uxgZuJ+=RQDh3577H7PFAfYyF=wRJ55aPuuUW814Htrmbw@mail.gmail.com>
In-Reply-To: <CAOQ4uxgZuJ+=RQDh3577H7PFAfYyF=wRJ55aPuuUW814Htrmbw@mail.gmail.com>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Fri, 10 Jul 2026 20:23:41 +0200
X-Gm-Features: AVVi8CcKiWkm6xoKpO6GLoDQetvLN0tImMPwxwYtq4HkU1puSjal02fIPnnUZPc
Message-ID: <CAJfpegvGnr2a3u9qTEVgZyUpeYF0FoRg8xzyGg1wfw88Os5rMw@mail.gmail.com>
Subject: Re: [PATCH] ovl: add ioctls to retrieve layer file descriptors
To: Amir Goldstein <amir73il@gmail.com>
Cc: Giuseppe Scrivano <gscrivan@redhat.com>, linux-unionfs@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, linux-api@vger.kernel.org, 
	Al Viro <viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>, 
	Daan De Meyer <daan.j.demeyer@gmail.com>
Content-Type: text/plain; charset="UTF-8"

On Thu, 9 Jul 2026 at 16:32, Amir Goldstein <amir73il@gmail.com> wrote:

> Ack for this, but please don't use mount/options/... it's a bit ugly
> because most mount options are not opan-able.

True, but I was thinking of doing this as a reverse fsconfig() thing.

> Please stick to something logical like "fs/layers/N" corresponding to
> ovl_fs::layers, where layer 0 is reserved for upper.
> We could also support opening by aliases fs/layers/upper->0 etc,
> but no rush IMO.

Layer numbering has been internal to overlayfs to date.  I'd prefer to
keep the layer enumeration that is external, which is the mount option
interface.  Works for EROFS as well.

> What I am contemplating is whether we should implement
> introspection of the ovl_entry stack for merge dirs in addition or instead
> introspection of fs/layers.

Interesting.

> IIRC, the root dir stack does NOT hold references to lowerdata dirs,
> so support for "fs/layers/N" is still needed.

So let's just stick with the per-superblock layering for now, which is
reflected in the mount options.

>
> For directories we could implement "real/0..N" with aliases
> real/upper->0 real/origin->1.
>
> For a regular file we could have constant aliases real/upper->0
> real/lower->1 real/lowerdata->2 and/or dynamic aliases
> real/data->{0,1,2}, real/metadata->{0,1}, real/origin->{0,1}.
>
> Those could be used to implement "revert to origin".
> Specifically, I think Daan asked for it during the last LSFMM.
> Although I don't think we currently store the original lowerdata
> in ovl_entry when lookup is done post data copy up.

I'm trying to focus on the "return an O_PATH descriptor for stacked
layers" for now.  It avoids having to deal with opening files or
directories within the O_ALT namespace, since magic symlink following
is used.

Thanks,
Miklos
