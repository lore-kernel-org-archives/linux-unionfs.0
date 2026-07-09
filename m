Received: from mail-qt1-f171.google.com (mail-qt1-f171.google.com [209.85.160.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35C123AF656
	for <linux-unionfs@vger.kernel.org>; Thu,  9 Jul 2026 06:11:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.160.171
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783577493; cv=pass; b=VCPmZ9pa7B97B026a1ge8CpyvjVptyLKuUUlV4pr02hiidpUthpnFhqg/hfa3ZulrRFSPS8lt0wG1+tMKj6N5EwhrD0kwE4LJ/Bk49v8qba3l0AoePAyQqK30XWLu34QRyWT1cmbVA15hL+B7Rh9nwGQhqUngm/7sJdIygCnt9c=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783577493; c=relaxed/simple;
	bh=9b1pHcb4tDFl3SXA5D25rB9XkxaOPF8WHE8yxdA4mAY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Sg+MWjAtGTN+ib9+w+qD8uSeN8WHql1c9gIb+UciOV3JHyBk6tCJFGH1kpWnrB/WybhIwqptvFsaUolxDr67KILq3A+EhpevrcGOKzyhOsFADxoPurPVP/kCbbu1AtcP4Tg34LAXjZcSknNtctqMAXTHfxiDjScZxFeVQ6ztR+c=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=szeredi.hu; spf=pass smtp.mailfrom=szeredi.hu; dkim=pass (1024-bit key) header.d=szeredi.hu header.i=@szeredi.hu header.b=NFAqoqmz; arc=pass smtp.client-ip=209.85.160.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=szeredi.hu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=szeredi.hu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=szeredi.hu header.i=@szeredi.hu header.b="NFAqoqmz"
Received: by mail-qt1-f171.google.com with SMTP id d75a77b69052e-51c2a818fc4so10094431cf.2
        for <linux-unionfs@vger.kernel.org>; Wed, 08 Jul 2026 23:11:30 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1783577490; cv=none;
        d=google.com; s=arc-20260327;
        b=fKArYSYAfMB+3HyFRWbEHmMV4y54izhRMkjLOS7nN/bc9DtKnZ+scqPmfCX+fkSB5j
         77oawuvKrEtbAhI8BqdfGXW5C107D8dL/3gmeuq6DgP0zNjo0V2zLT2yh51BfgWZdKOA
         YpD99Hs/6KMhoSCAgbaf8BxlI7ZTcYz5FoiFawNY3yHQlv8fgxkVug2Dka1WnCjpkcdl
         gqLXIhfQczOnMQdxELxsGxYz8KRUJk87tHUj/5AvNAtzmLhBJk065vocAbm47nq+OMq5
         KP6jbySSa3RidZbmzMeT87vNl4+xuiXFnWjApji1Hpw0k1eAoqsB2O/RZApZscgoh3dz
         Lkeg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=dQTwiRoPjnPhFOLmv3RgpTRjzP1fhVs+pKfZMaiYyTw=;
        fh=sPe/eK/A+ebhTB4m7Mepcs4ZeppaAx7D0fyCTM6sQjQ=;
        b=pl087R2Gxp68FCPVvKz7tjYlBruzx7gOALi7tn6EGwqDVKewhtdfmMKZeBazpTZdNQ
         VCUxlj4FdYtKEB1qthQ4VKP0Xiqgm3P+QRgrxVSMgSy+60emYKHFc2SGWs/xDththFm1
         1j1iiZEqGqxUmBsBoTgE7WCiBBNH89WS9uHETxkEX8r1H5lN/o0+qiznhKV6frd+VG4D
         t/NAy44/a7JJutQVCJTsxYFGRoAfncVn2dEJWndq2djapBY/9XsoKnMOZAfoR2fW1QxT
         3k9+B1ZABnNh92gWenMk/YT47S0GoTm9QgxojXP/jdcqw7t6Vv3VjfSh5S/Oks8idvyx
         orzQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=szeredi.hu; s=google; t=1783577490; x=1784182290; darn=vger.kernel.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=dQTwiRoPjnPhFOLmv3RgpTRjzP1fhVs+pKfZMaiYyTw=;
        b=NFAqoqmzRE+v4seoIqH9pEOna0l9VfjuaIKSQx/vXdYmNcQjtGl9v5loyKJWQtQjOg
         YI9YzoSz6bD7CRsfmfRXInTQ9QcnPVcbUGLg0/1eJ/zdUm7vHyrHNTglOBqZo36HrWUk
         orSqDqWGcruhNcI0qT2gS+OzJRTG33wCbHxy4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783577490; x=1784182290;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=dQTwiRoPjnPhFOLmv3RgpTRjzP1fhVs+pKfZMaiYyTw=;
        b=SIPRkS5MmqPT3FoEj6NCR3CbFb1m4Fxe51y9vQcz5jfsTqS6dKxnnVIDREMpXz4ifK
         IZ+A6GUj0avT/f19g19v5xH/ElZhsbLgiD2Pxhk2suKXPzBpu7aeDFz4VkFMWDqBPSge
         lRFc6+7TVKE5oQaY84RMadeShcbUhDalpjW7YL95WSJkEjbx/GWpSLu+ME94hz9+iyvu
         ot1sZ5vpCMIDpN/0oPWBwLvFHP0EdCvZhKgMj/WanrkcUytQ4cLVAuU4oH0vo7LTjoqg
         ogrEKFrUmt9CPLLlUjQae6Uv0O9ZQq0hVCK4Kkb5XlhXQZO89Qafdn5PrhqzhSB6sETp
         X+6g==
X-Gm-Message-State: AOJu0YxgV0TZEItCl85kSa7sX4D2f17Dt+OvRP8fo0r74m4ein6Td2Mi
	cb1kFr2n52tijMIM3s46lpY0RiES/Q3lvwBTriy3wuo2TMhcgD1aNdngtKjYoAEDZfH/qd+3j1o
	uBhtIW+VJxXwCxFH/qP1pKHrmArynTiJX9bzXfqoPgg==
X-Gm-Gg: AfdE7ckT/cyjw6iRQJgJbnnqMtQVaVGHd92hao9TvSkny6CdG+4D9TfDOGoPUAxpgis
	QD6IGWHGdbir5EqJwFpLsDiKCJRlXswKiKgn0UA0pT8luMAKayKM3JUFv/EVU4SbSTZFqvtkaXc
	gTLFyT+oaR5bJFUh4Ar69dXyo+gr7Q1gjUsC1d19g78Ytl6vDVb3l3tOaRkV1X/ln6rH5VcJi+K
	HeN0VoFOJjU5n87DQqIYl5NcgEtOjossbhsRXIsb8xFjbw2JX/aT0/IvWF8lEQeRkaqf9vUeStQ
	GwlYivfduFvr+HrOP9Tn6Xwg68g=
X-Received: by 2002:a05:622a:2cd:b0:51a:126c:c6d9 with SMTP id
 d75a77b69052e-51c8b431bf6mr60467911cf.26.1783577489970; Wed, 08 Jul 2026
 23:11:29 -0700 (PDT)
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
 <87fr1t6wyt.fsf@redhat.com>
In-Reply-To: <87fr1t6wyt.fsf@redhat.com>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Thu, 9 Jul 2026 08:11:17 +0200
X-Gm-Features: AVVi8CcVEq2J0Va4XFUVsVlovcTwuzY96sGW-KM_Jfd0atcnoi0NWAC1g8xQ0Hc
Message-ID: <CAJfpeguPzVqm7JqJhe2CpfHMcAiETGT4_e84cFBEWESr5RpEGg@mail.gmail.com>
Subject: Re: [PATCH] ovl: add ioctls to retrieve layer file descriptors
To: Giuseppe Scrivano <gscrivan@redhat.com>
Cc: linux-unionfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	linux-api@vger.kernel.org, Amir Goldstein <amir73il@gmail.com>, 
	Al Viro <viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>
Content-Type: text/plain; charset="UTF-8"

On Wed, 8 Jul 2026 at 22:35, Giuseppe Scrivano <gscrivan@redhat.com> wrote:

> Would you be OK with the ioctl as a solution that works today, and
> duplicate it when an alternative API materializes?

Let me have a go at the pseudo fs interface first.  I can probably do
a quick 'n dirty prototype within a couple of days and see what
reaction it gets...

Thanks,
Miklos
