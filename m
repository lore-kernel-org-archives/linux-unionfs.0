Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="RYNTvA70"
Received: from mail-qk1-x732.google.com (mail-qk1-x732.google.com [IPv6:2607:f8b0:4864:20::732])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C2EFCDE
	for <linux-unionfs@vger.kernel.org>; Tue, 28 Nov 2023 10:40:30 -0800 (PST)
Received: by mail-qk1-x732.google.com with SMTP id af79cd13be357-77d90497b86so182851685a.0
        for <linux-unionfs@vger.kernel.org>; Tue, 28 Nov 2023 10:40:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1701196830; x=1701801630; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=FStUrpaqYx+yJrAjYizTMoKJoTj2/dVt84vrYBAnCOs=;
        b=RYNTvA70pxkvedE7ioYQyvRTfuIPCO1q3XOFs67gr8d5u81u+ew2jcqNvaIF9P0tUa
         Z3yBlcZrYTLN/ucD81QPRN+I+sBZMvpIs9xdwS3IZOFWucrZABK9Ftf248CsADcCCxO1
         qcusohBV48cEpLBge37QZYTu22GOVF2F3zc4CbOH9bZOs8LrptR7u0Ew5XaKA8Xy72H9
         pOHsMfpbagdC62lJEo4aGhB0TzgGzaF26F1ulGLQ8nfdrPn6VjKrBz2xc5v0SaQQosW/
         ocH2vRRhYuM5FzYRCmq3bqQu/kd+1SjL5m1GrS6hyv+OgkkFSm1fl2rG/o/GiD+Bji7H
         CSyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701196830; x=1701801630;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=FStUrpaqYx+yJrAjYizTMoKJoTj2/dVt84vrYBAnCOs=;
        b=KQc3Nexi4kZfqUloFZTagwLGfMDgidcx07vEa5fk1Zjrjh6WXC6TLvuPSwieywzld8
         DkAknoYM8AzYb5KUhnxvVsu3Mbc5LpUAUJaR7vTOe6qKg5fkTzjTDwavFscknmALGN3l
         ruldL6r29sz9OewDcpS72MZBgbJwkZMQZuyhOB1gEjRlj+TKSJNb0U6OQX5vP+1aHgO7
         gsjaBlPeGGtg3+Kdp9jwUjFaZBllPJc35wAnls35euhQ5IY8EtDIeT7d5x53e6DZw23/
         L8+xzob83UmVOAYZe1HM9Yndj8h9fVB0P0ETsza7di+7LlRyrj/JliiQh1GnMa0/1W9B
         duXA==
X-Gm-Message-State: AOJu0Yzx5kXHSmwAeFf7miEmDjENckxNtMdVp+vF569lTID8NN3yr8ed
	/orE30SQABoL2tHJBtF8O5otTm7w+8+PeRxqk0E5z9leDBs=
X-Google-Smtp-Source: AGHT+IF5Pj49+laMsAov/PY5jXXObJWkHGugjEiNsB47gzdWLPfAD7f7fWCMjjTOBISyBQowAekGylRQbiO6OIwjQ2Y=
X-Received: by 2002:a05:6214:29e9:b0:67a:1ed1:ced4 with SMTP id
 jv9-20020a05621429e900b0067a1ed1ced4mr17689779qvb.45.1701196829929; Tue, 28
 Nov 2023 10:40:29 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CAJfpegsexQsNVMOZw+0byzj2wTbU_Tg6p0ATgwBAwmTaDmNbLA@mail.gmail.com>
 <CAOQ4uxjYGckJA=raAW8wyVmDaK-FXfFDRS0RCpZYcLucPqMi3w@mail.gmail.com>
 <CAJfpegt5COamxm-ZN+A9ub_Te-CPM0xMd-Rrzwv7OHBkvHS3yg@mail.gmail.com>
 <CAOQ4uxic3NDtEt9EiP+RYKGEB=6b_PCaudQA=cXK6mWY4Cmeqg@mail.gmail.com>
 <CAJfpegsr3A4YgF2YBevWa6n3=AcP7hNndG6EPMu3ncvV-AM71A@mail.gmail.com>
 <CAJfpegt7VC94KkRtb1dfHG8+4OzwPBLYqhtc8=QFUxpFJE+=RQ@mail.gmail.com>
 <CAOQ4uxhg+0_S1tQv9vUpv7Yu-VRLv7U7cnxLmxig+9LmS_qW+A@mail.gmail.com>
 <CAJfpegu6cESPijvO51zjVeXA=wcw7nMaNkkNJ7+my07wq8k9FA@mail.gmail.com>
 <CAOQ4uxicurA4nNeDkUarkTMujtsaOvwQ8HEMpz97N2SejBRx9Q@mail.gmail.com>
 <CAJfpegv=UXqYQzvH6+py76MV7+5L6=3a+_J7LpHQ0VK5YYrAUA@mail.gmail.com> <20231128151123.3cnde47qum52vrxt@ws.net.home>
In-Reply-To: <20231128151123.3cnde47qum52vrxt@ws.net.home>
From: Amir Goldstein <amir73il@gmail.com>
Date: Tue, 28 Nov 2023 20:40:18 +0200
Message-ID: <CAOQ4uxgaib8GW8-5U-XXVyvJWNUYtjaZpHpXieBqJkKW0i3StQ@mail.gmail.com>
Subject: Re: [PATCH] ovl: fix regression in showing lowerdir mount option
To: Karel Zak <kzak@redhat.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, Christian Brauner <brauner@kernel.org>, linux-unionfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Nov 28, 2023 at 5:11=E2=80=AFPM Karel Zak <kzak@redhat.com> wrote:
>
> On Mon, Oct 16, 2023 at 03:10:33PM +0200, Miklos Szeredi wrote:
> > Ah, but it's not a regression after all, since the kernel un-split the
> > same commas until 6.5, so there was no way the libmount devs would
> > have observed any regression in overlayfs mount.   But arguing about
> > which component is the cause of the regression is not very productive.
> > Indeed libmount can be fixed parse overlayfs options the same way as
> > the kernel parsed them before 6.5, which is probably a much better
> > fix, than a kernel one.
> >
> > Karel, is doing such filesystem specific option handling feasible?
> >
> > If so, then for overlayfs please please pass an un-escaped (\char ->
> > char) string to fsconfig for "upperdir=3D" and "workdir=3D" options.
>
> Committed to the libmount:
> https://github.com/util-linux/util-linux/commit/f6c29efa929cb8c741591ab38=
061e7921d53a997
>
> will be in util-linux v2.40 and in v2.39.3
>
> It's implemented for all filesystems, not exception for overlayfs.

Nice!

Note that this code:

if (*p =3D=3D ',' && (p =3D=3D optstr0 || *(p - 1) !=3D '\\'))
        stop =3D p; /* terminate the option item */

...
        strrem(p, '\\');
        value =3D p;

Will not split either of the following:
b\,a\,r
b\\,a\,r

while legacy overlayfs does split the , when followed by \\

IMO what you did is good enough for all practical cases
and there is no need to go down the rabbit hole of proper escaping
(unless bugs are reported).

Just wanted to point out the difference.

Thanks,
Amir.
