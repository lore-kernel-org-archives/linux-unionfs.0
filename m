Received: from mail-qt1-f177.google.com (mail-qt1-f177.google.com [209.85.160.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A97C81D5CE0
	for <linux-unionfs@vger.kernel.org>; Fri,  6 Jun 2025 09:33:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749202436; cv=none; b=s1GmVjVCl51trhRuipMNy99B8pYQkqcKEhEyfElhmaCc4H+egR0Ijtv2F/6DCBhOaRh14gU54MpUNFdyWOqft+tlpGpsbtW+wT2FbkdbVbbvgMeySHxFFkRzAKw2V7mH6GTrbMKTa+JF2f1Gr2yUDCi5i3CD5edWjCA6WgZvqTI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749202436; c=relaxed/simple;
	bh=NCD3FsHqX/tDsdqDrxlXUdzTVx+2sqRGtUtrxLK6jAc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=LTp85mLTHkqC6B/JtzMvMtiZZIpDqHE6qgeZNRCimS3nLfVFQ74IKIsR/jRRdsp86h5/J8nQ3c7eHqB3Oqab27wQrpbEFXr0wwf3+OPuhWcFvGxYFMwjbbQ/dKTFLsZFz+kl6gRdQT874iq9M6we3zAQ3lsFxcaoJUD/wL9X5FY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=szeredi.hu; spf=pass smtp.mailfrom=szeredi.hu; dkim=pass (1024-bit key) header.d=szeredi.hu header.i=@szeredi.hu header.b=lvAG+tHk; arc=none smtp.client-ip=209.85.160.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=szeredi.hu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=szeredi.hu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=szeredi.hu header.i=@szeredi.hu header.b="lvAG+tHk"
Received: by mail-qt1-f177.google.com with SMTP id d75a77b69052e-4a4312b4849so23564211cf.1
        for <linux-unionfs@vger.kernel.org>; Fri, 06 Jun 2025 02:33:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=szeredi.hu; s=google; t=1749202433; x=1749807233; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=kjjJoIKAqPL4Fi3nMaT3Fad+/StO4aRC+TRTWdCbeTc=;
        b=lvAG+tHkEIFwrw/yQXFUo0RH+vfERl2p/X23Pzswzv4TaPWDxbepHDZIr3RmqV7aCq
         eaYotMiBY26iIMwt2AJx45me/PQfzUI+tHBfPK4n3fEhAmGz0+VHSoA3l8qW+pik3ND1
         xvYFl1SOljGyKrq/Hwp/2q+u8k3l9uDXzQvJ8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749202433; x=1749807233;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=kjjJoIKAqPL4Fi3nMaT3Fad+/StO4aRC+TRTWdCbeTc=;
        b=tJ/WerDnAh6UqMyDSG1tsMuAUI6YsLckDu5FH/NXHIuziThiAtV9SG0MPTATDs+6Ww
         zWMS12LLMAU7LmOYEoy4+m2SSxsIMFOz+yra3KJa/Q/q7wevG5UTo/XuduLo1lFis8MR
         zW0niEQCUTv6dpj5ECyYvxWlifTqo0I41nn1tEJ27/ojwWbAXpKkOaaVAa8V8JAt2cL0
         TL21RcoDwGPzw89I34Ykfc3weElZNoiWCM7Dzbrbd5MNWy2RFX/A09oDwUtzWWOJ/R8n
         dbWO5SnAO801VCU7Zr9YkI482/OEjak+xAUtvQdGhABbBW5Qx9lqJrzVr0eN0yRISUz8
         q0eA==
X-Forwarded-Encrypted: i=1; AJvYcCUTNzSPS7fvOzehjXhaQ7D2CbzO3XlnW/xWyZd/2BZimv593QTgGAMnxMm6eeMfOJbSZRgpY9aVy6v1O21W@vger.kernel.org
X-Gm-Message-State: AOJu0YzUXL2zbLtQWze2QCbDVnoC7m51XBsb6Yit1m2Vi4cQ5BNRxcQI
	0501JFB1YaQvD+ERokRPCvsZatreeOsGtfBw/b/fqycVj228PtCighJuwo61nI4Jks01NVGDB3G
	NWqS/ft7uNcZ8FBwiEx/Oj20ERczGKxxC4tmBle8d9Q==
X-Gm-Gg: ASbGncvk4JcQE3dVoLqMJU6f2hZ7F7/TtLvpzTwTy5TnyUU0pdPiyZIwkMqCEoxcT/C
	79N58EIaMhMgKs27iEnm/YW3isSzi2R7GQoO8C54bvuS4mooUm01Xh9ho8Tf584MgKj0VP6yAfw
	9oOK6GaYL+sXPqNactgkYcBiwVl03qkSk=
X-Google-Smtp-Source: AGHT+IEpD8A+u93yY7dMI4QI7COmSAbaXPHLO6KjHqBSEgUYxk/Jw0ZYl1TrJ9sLHanEFIt9Z9r1xEAOroted7uPQME=
X-Received: by 2002:a05:622a:428c:b0:48e:1f6c:227b with SMTP id
 d75a77b69052e-4a5b9a47e1amr44216851cf.26.1749202433527; Fri, 06 Jun 2025
 02:33:53 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CAJfpegvB3At5Mm54eDuNVspuNtkhoJwPH+HcOCWm7j-CSQ1jbw@mail.gmail.com>
 <CAHk-=wgH174aR4HnpmV7yVYVjS7VmSRC31md5di7_Cr_v0Afqg@mail.gmail.com>
 <CAOQ4uxjXvcj8Vf3y81KJCbn6W5CSm9fFofV8P5ihtcZ=zYSREA@mail.gmail.com> <CAJfpegutprdJ8LPsKGG-yNi9neC65Phhf67nLuL+5a4xGhpkZA@mail.gmail.com>
In-Reply-To: <CAJfpegutprdJ8LPsKGG-yNi9neC65Phhf67nLuL+5a4xGhpkZA@mail.gmail.com>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Fri, 6 Jun 2025 11:33:42 +0200
X-Gm-Features: AX0GCFvFo8VWZRAyQvoO_OwOv8y44RwyQfaZo7GsgVMP1nOljN6vif8ZNW5sSOg
Message-ID: <CAJfpegu1BAVsW5duT-HoMGiSXNvj2VsLNfTuzvF1-RLyVLDdTA@mail.gmail.com>
Subject: Re: [GIT PULL] overlayfs update for 6.16
To: Amir Goldstein <amir73il@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, 
	overlayfs <linux-unionfs@vger.kernel.org>, linux-fsdevel@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

On Fri, 6 Jun 2025 at 08:36, Miklos Szeredi <miklos@szeredi.hu> wrote:

> I'll redo the PR with your patch.

Pushed to #overlayfs-next.

I'll drop this from the PR, since it's just a cleanup.  It still won't
break anything (and that's what I meant by "trivial"), but it can wait
a cycle or at least a few rc's.

Thanks,
Miklos
