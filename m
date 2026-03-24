Received: from mail-ed1-f46.google.com (mail-ed1-f46.google.com [209.85.208.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5A033B47E5
	for <linux-unionfs@vger.kernel.org>; Tue, 24 Mar 2026 19:09:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.208.46
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774379391; cv=pass; b=fWfxwKIP6EOrsRIOdsTTZj3Pjmb2+lNU1FRgqQlWaOC3BIT7lmAAcLsMqiOGR7dfblifaY0dFmp0LXJ1n/LMNVurPUCGMUHJUcMyBQ4gLB/uv9a2kl/pNjiCY0eau1mdDjkbzeVg3/cRVMRxCtB9Y7/S9xaPTBtiAugzL3wLxH4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774379391; c=relaxed/simple;
	bh=ga4JV9/szVDdjkZ43SYWlrewDuBoIpvwjFPyFW+tFfI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=EEySl9/kQwNYMZfbM4z2cLtXvowT2MqXbwIj6vKKMMR6rAXyrZ5pEViT5t2JjtTw6ogc3088/rsAMxoh32QQyELPzVl0dnCBNJQ6lXopr1MnlD5w3LpuxVcmrTz4VyPHHZcMLdV4GI46AKArQscg3hOMvbEJ6/+3eG6R0SmmLe4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ml2A5gc2; arc=pass smtp.client-ip=209.85.208.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ml2A5gc2"
Received: by mail-ed1-f46.google.com with SMTP id 4fb4d7f45d1cf-666f646f5cfso289836a12.1
        for <linux-unionfs@vger.kernel.org>; Tue, 24 Mar 2026 12:09:47 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1774379386; cv=none;
        d=google.com; s=arc-20240605;
        b=PFwpfg8u1fBsfCzDPRGHt+0eSfjNcI9s7GWL4g4iX8pXlPfoT+ki/bLHDDtlNXbTut
         LorIFE4J2xYmiC5NlaJaQ7oc2k/N2Z3oNrGXIEi0s7A0XyWMdyjgMML/kPNFBns7A1UZ
         fFCw6qIlD9yf9u0SUNouSOHnLomOth2AWEcZvoHYsnjajy/NtGlO5ZeXpIyfg7lkdaNA
         h27ikmqJAWN08UaYILRn2naF0EYpskJLfTwRwiR7fY1+CKD3VZCzGWbzfqKOWQuGtAQ+
         8WABLhkUUbyqYypl5ZGP6UgZ46IZUAg0HXN8LYtRQhLdCzcO+SWBkoKl7GZfaJTzzjqN
         HLhQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=ga4JV9/szVDdjkZ43SYWlrewDuBoIpvwjFPyFW+tFfI=;
        fh=l8pk/kQobvkaiivrILOvxDJqeejNSMbSg2D6CHbuNSM=;
        b=RoEyX+GkUmwtPJlX9tutsmOX+UWx5Vlzv6QlBHIQJSKgyg0WUMW+/zR3fsvzs8Bw64
         +HrZuiK/zrL7K3kPf97oFcVqi35djhcCQoZrHQplCwd0yaqyveXLaElINQfjG3YRV5n/
         0xYYYyKmLTzLAj+D3ZGSZ021Cvn/2OUpfZRZjSP4G4FIM9OQqcX/EBkxSmeBNEqgNb7N
         njFXgU5I8m6MJgSQIPoGdu61KjxPX5IdAS8tJmd9yOQGxm9fj8Uwn+w/tZAkax+rYAGl
         FYB9k9VHjfdUiOt5Mq7mDFvUn2OHxeW6ty2gHVjtIFuJpw/+ipH6Ig5i7bZcm77khq3f
         XG4Q==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1774379386; x=1774984186; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ga4JV9/szVDdjkZ43SYWlrewDuBoIpvwjFPyFW+tFfI=;
        b=ml2A5gc23gixB6w2ls+wZD2LzDVFGcFqVAWFp5zsZv/MTpUePrCo+GHu/6tHQFzwTI
         7IhsnArMGNH2e3jlv+eNSqD04QiwQ1L1uXA71LjyFfMYuE75zlikwCu2B/dDphs3EcJV
         0L8HDliyyqdMqL6NwF49ZCn6bRqZ0DwQ570biJ9lBBBfVvi7KV5KyNbzfpEp3teRKabs
         4a16yx5QOxVLZtA+vYg/8bj5uImShoPztCO7zkIWFvlXJt+sdE3uLP9QkE2VOkKRqcEL
         +cX+jaLZBSQ5affNchdCwL0VyScyaFNOf1RTe6dukca41DUC6z2uzIYEX4KfeUq6jK8x
         HeWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774379386; x=1774984186;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=ga4JV9/szVDdjkZ43SYWlrewDuBoIpvwjFPyFW+tFfI=;
        b=gDGGoKsQMI5P9+K4yRDr8XZJIhmO5Ur1m5AmX1OndkAen2pTPQVlPwjE3uhGf1HPtD
         F/1pE5D5Fiikozfq71db9K16AQdWQfNonXTn7uBPZrz+N2Ac2rR+bzz5DWNrKo1UC+zb
         hmh0DPNhUMPt1kh5yatT1L5Cq2wuzN02s+MskgT7zSyRNDNzYGFd2y9Wn4bBwYTaBfPB
         6beF8MskOBsJuGyD7V17g1gYES6+/AIOQc4ZdvRUblXoMEW7g10AK/7Ub+OVp7u58RMX
         3Ur8pisvdRdAh/nCOED5kFvaEuGM9uvhKNNjhP5+GnApiIP+mi7JDYlwXm9q460fkwvc
         61JQ==
X-Forwarded-Encrypted: i=1; AJvYcCXL/mX+eYEr3tkm39dstPrtVxkbWd/X6eoTyYVMu1X+wKhWq7rWeSIRzQnOT2bkNoXsiZJqpL+6Y18o4L7E@vger.kernel.org
X-Gm-Message-State: AOJu0YzzHoKMKdB1nektjOWO1x1zI9mohivY+IciDF+iynl4+aCxjDw/
	5rK02+JHQpZ9HR9iBMI2H9ER6aFlQ2+NXEs7TYJ/Yk/6dNOm2gtyirdpNLoj0DLPKlGe5Md0OuU
	ehbQwyygoQTEkHqzH4/zAQPVimo/Jgig=
X-Gm-Gg: ATEYQzyoclDauttYsFaiQRUrGUpR0Iuy3O71TGziJ6OA2gh0Gs5PtctruLf2Vord9HT
	jU9QbuWqG7o7CQK6IzhHXGp09i1oyQVCsmmpNV+BW+ckygsLGITNJjQtvLs2TVgQL8CjG8DJbl7
	4LnAX0FiIjx4C1obgnAGqPVwNpoN3cH9qDi2ZAYTZ4Udk13DFbxX8yR7UEckD8HvMGBeDBwzWlp
	0fIKXuppFojSzNlDELaMqtSMDzoHCzEBJourNPuMJ/mbAwiyiAmsjc1dvHjEIePwMyv6ZSr6Opb
	m+bUzp1YYgT7g0S/AxkqsD5z5hcOyTbU3dfCbxozJw==
X-Received: by 2002:a17:907:d506:b0:b98:65e:8fb with SMTP id
 a640c23a62f3a-b99ae1f8cecmr68146766b.5.1774379385581; Tue, 24 Mar 2026
 12:09:45 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260324145750.90719-1-amir73il@gmail.com> <CAOdxtTY0jsqrJVXH=eQzYcowEpkDxwrk1DMgg8QD4ojygWJQ_Q@mail.gmail.com>
In-Reply-To: <CAOdxtTY0jsqrJVXH=eQzYcowEpkDxwrk1DMgg8QD4ojygWJQ_Q@mail.gmail.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Tue, 24 Mar 2026 20:09:33 +0100
X-Gm-Features: AQROBzAWKQvwMoV1EBx8nxLnWhG3imj_5RCL11KUWt-xZJuWrBziHsnhxgQh7j0
Message-ID: <CAOQ4uxhdpJ5+awnceRzRxmP-ot25_w0LogLYpncLJZXxQOj33Q@mail.gmail.com>
Subject: Re: [PATCH] ovl: make fsync after metadata copy-up opt-in mount option
To: Chenglong Tang <chenglongtang@google.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, Christian Brauner <brauner@kernel.org>, linux-fsdevel@vger.kernel.org, 
	linux-unionfs@vger.kernel.org, Fei Lv <feilv@asrmicro.com>, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Mar 24, 2026 at 7:04=E2=80=AFPM Chenglong Tang <chenglongtang@googl=
e.com> wrote:
>
> Hi,
>
> Regarding the patch: because we are currently locked to the 6.12 LTS
> kernel, this patch doesn't apply cleanly to our tree (due to missing
> mainline dependencies like the str_on_off helper).

Hence:
Depends: 50e638beb67e0 ("ovl: Use str_on_off() helper in ovl_show_options()=
")
I added it for bots and humans that do backporting to 6.12.

It is not a "real" dependency. It is a weak dependency for clean apply
which works well for 6.12.y.

>
> Since we are actively tracking this for a Google COS customer
> escalation, do you have a rough timeline for when you expect this to
> be merged into mainline and subsequently picked up by the 6.12 stable
> queue?
>

It's queued on the ovl-fixes branch to be merged into linux-next
tonight.

If there are no rejects from bots or humans, I plan to send it to Linus
before the weekend.

> We will officially pull it into the COS tree as soon as it lands in
> linux-stable.
>
> Thanks again for the excellent support,

Your report was very informative and well prepared.
This helps :)

Thanks,
Amir.
