Received: from mail-ed1-f54.google.com (mail-ed1-f54.google.com [209.85.208.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F0A31C2435
	for <linux-unionfs@vger.kernel.org>; Fri, 27 Sep 2024 19:47:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727466460; cv=none; b=FjI1wbtMGQ/IUSpO8SwJFWPWP65vIprjSVdrCKvqNA5syDweJxljbacrT6ttV1QnrMS18EbHBXGNAEfDLvmF0IqNs2cntG3g/15x6VBvnD6QaY2gipNDjefXCEGam9leMiczgThkcIn4fgfHTJTY0YU9sZg+xcyqnXlbl0OTUOY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727466460; c=relaxed/simple;
	bh=K8LRS5lXD/WAyJR6Fah4BgddLYPaV1DDmCZ44umWmfE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=JqwXJGin/XHVuFsp0z5mTedSXXl0Htl3FeRTACUB3z6P928x+b1gqWS0XMoBhJX1eUAYzreNCchEvEwwmIA8pwBmLqHWyQxvEtbS0NfGgDTmxfTHj4EUwIR1IvPbzR/qJXmz9q2/mIoKxUjnHL0GYmvIRFNHYU8KU0HtGHs/yaA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=XANP4D63; arc=none smtp.client-ip=209.85.208.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="XANP4D63"
Received: by mail-ed1-f54.google.com with SMTP id 4fb4d7f45d1cf-5c718bb04a3so3090965a12.3
        for <linux-unionfs@vger.kernel.org>; Fri, 27 Sep 2024 12:47:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1727466456; x=1728071256; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=53HOZed5FIyfCoU16tivT3Dit2MdvJuxNAeOr42Twwo=;
        b=XANP4D63u6u1pcwJWq5t2gr2/HAi7sdxFAKvSviD15mhTiUCk4OWffK/cEGJ5pVyfx
         iGtS5LfJuMlT4i3tP+29LO6AKG7dHZlwYa38N5JtJ2BpPee1kaQMWvFm9sMtbVKopD4C
         zRRR7dcvE50xAjWwKKKCsxiHF1sxcRhq79lN0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1727466456; x=1728071256;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=53HOZed5FIyfCoU16tivT3Dit2MdvJuxNAeOr42Twwo=;
        b=uFfMAEcZt6WCC8VV+rCEtr3j300uF25wwV2aQTE7QglI/WvtMOnBCx7Hgc7MS7xmfr
         HheJGKDr9IZ0lzS4M62XISatShNoAnRJ4FQZTNXc6Lecdk1ujHWUsuGE2f7+WDSmn8PA
         Ffnl1d9SNwlty2/mVv0Dm06nbvFd9rAGvrpwlTVC0zZx+VXgoTwP1vGYJyEGPrD2AjEC
         slilTGYaL7235Kf4THSM40PAh2jDlZVwXd6hneFxc6wJhgfxRlO2vWgK5r1mRz2Yb8V7
         doRQkqIyk2iujErafsCWDbXCdNDDW8c1mKnU1qU6w13kMhll6S/gmxtxhuXjNogyoKth
         2Myg==
X-Forwarded-Encrypted: i=1; AJvYcCWDHzRoRVmZfJg17st4TsqCpq5II3elsLEDNcfrDej/N0oy3rZGuqy77veoOUkz3f2Qtj4ZwuC4GmjvOk6a@vger.kernel.org
X-Gm-Message-State: AOJu0YzFSueFrRb62AYHJBj/rPQ1c4aACbE6w+959xIkpCpGo3k7OV/r
	PzGC0+BGGsQxMPEBvmk3cPt891uqnu/bqIO0d75EjEGF5LrCpn9FmIxYbEjDr3sp+pCoHRY0J/G
	Lqc1bmw==
X-Google-Smtp-Source: AGHT+IEbx2QQB3QHaHpKga4hr06fKvaUt0GCzI+VUJa9GwKeR81+jS4yPI1qtQOpU1Uxr6VpVFuKCQ==
X-Received: by 2002:a05:6402:e99:b0:5c5:b9c2:c5bb with SMTP id 4fb4d7f45d1cf-5c88260842dmr3998618a12.35.1727466455579;
        Fri, 27 Sep 2024 12:47:35 -0700 (PDT)
Received: from mail-ej1-f47.google.com (mail-ej1-f47.google.com. [209.85.218.47])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-5c885f5336csm553447a12.97.2024.09.27.12.47.33
        for <linux-unionfs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 27 Sep 2024 12:47:34 -0700 (PDT)
Received: by mail-ej1-f47.google.com with SMTP id a640c23a62f3a-a8d4093722bso347131866b.0
        for <linux-unionfs@vger.kernel.org>; Fri, 27 Sep 2024 12:47:33 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCXo7a1I8yFVWPx16Q9+sHBctF/UR+M1ngI7eKk3KYIflunGrzIXcz/gAPJevRUvCIgEb6cJpAMZ85b35M4p@vger.kernel.org
X-Received: by 2002:a17:907:3f1c:b0:a8a:837c:ebd4 with SMTP id
 a640c23a62f3a-a93c4926f43mr470113466b.27.1727466452677; Fri, 27 Sep 2024
 12:47:32 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <k53rd76iiguxb6prfmkqfnlfmkjjdzjvzc6uo7eppjc2t4ssdf@2q7pmj7sstml>
 <CAOQ4uxhXbTZS3wmLibit-vP_3yQSC=p+qmBLxKkBHL1OgO5NBQ@mail.gmail.com> <CAOQ4uxiTOJNk-Sy6RFezv=_kpsM9AqMSej=9DxfKtO53-vqXqA@mail.gmail.com>
In-Reply-To: <CAOQ4uxiTOJNk-Sy6RFezv=_kpsM9AqMSej=9DxfKtO53-vqXqA@mail.gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Fri, 27 Sep 2024 12:47:16 -0700
X-Gmail-Original-Message-ID: <CAHk-=wikugk2soi_2OFz1k27qjjYMQ140ZXWeOh8_9iSxpr=PQ@mail.gmail.com>
Message-ID: <CAHk-=wikugk2soi_2OFz1k27qjjYMQ140ZXWeOh8_9iSxpr=PQ@mail.gmail.com>
Subject: Re: [syzbot] [overlayfs?] general protection fault in ovl_llseek
To: Amir Goldstein <amir73il@gmail.com>
Cc: Leo Stone <leocstone@gmail.com>, 
	syzbot+d9efec94dcbfa0de1c07@syzkaller.appspotmail.com, 
	linux-kernel@vger.kernel.org, linux-unionfs@vger.kernel.org, 
	miklos@szeredi.hu, syzkaller-bugs@googlegroups.com, skhan@linuxfoundation.org, 
	anupnewsmail@gmail.com, Christian Brauner <brauner@kernel.org>, 
	Al Viro <viro@zeniv.linux.org.uk>, linux-fsdevel <linux-fsdevel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"

On Fri, 27 Sept 2024 at 05:41, Amir Goldstein <amir73il@gmail.com> wrote:
>
> Too quick to send. I messed up the Fixes: tag.
> Now fixed.

Applied.

However, just for the future: please send patches that you expect me
to apply with a very explicit subject line to that effect.

I get too much email, and hey, I do try to read it all (even if I
don't answer), but I'm really really good at scanning my emails
quickly.

In other words: sometimes I'm a bit *too* good at the "quickly" part,
and end up missing the fact that "oh, there was a patch there that I
need to actually react to and apply".

That has become more true over the years as the individual patch count
has gone down, and *most* of what I do is git pulls, and most of the
emailed patches I see tend to be things that are for review, not
application.

Yes, I picked it up this time. And maybe I even pick up on these
things *most* of the time.

But I still strongly suspect that to make it more likely that I don't
miss anything, you make the subject line some big clue-bat to my head
like having "[PATCH-for-linus]" header.

Because even just a "[PATCH]" is likely to trigger my "patch review"
logic rather than something I'm actually expected to apply, just
because I see *so* many patches fly by.

This was your daily "Linus is all kinds of disorganized and
incompetent" notification. Making things obvious to me is always a
good thing. It's why those "[GIT PULL]" subject lines help not just
pr-tracker-bot, but also me.

Thanks,
                    Linus
