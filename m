Received: from mail-yw1-f182.google.com (mail-yw1-f182.google.com [209.85.128.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD33136A033
	for <linux-unionfs@vger.kernel.org>; Tue, 23 Jun 2026 09:59:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.128.182
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782208799; cv=pass; b=MgHi0CtmopOBKFg+jaAxL5j90on1P17iNLpX6kQa97EzVbgAA8UwaD1hdJIfQ6AYnlCWS1BXGyjN0cBFpA8Eh2NN2QXtB2QtraEBz4XEbww+aSJ1dYPHgG+8cqflxOP3sVrh8F+c4khOuE6a5OPeavwC/JCW/sKQdzLCZKgK92k=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782208799; c=relaxed/simple;
	bh=mmXf8HVuYpDKq+qcKwNI47Acy6XixRYMjWA2gHcrCvI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=u1kTQcFl0eTi0REVqHTGeXE50Bg/5td25uDb85CGNPtMBsJLKmFJX6B3YO/crEW4AAP+AB4UfnWOqOCxiAbqmfVx0/lBiHMd0gdxM1dcsa0EAb+X+9x4s6NqGZ2O14RWBWapW2gTeE5PIjZ4EsUWkSMacDXzfatbG1eaY0L6Z/s=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=fSpeELSM; arc=pass smtp.client-ip=209.85.128.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="fSpeELSM"
Received: by mail-yw1-f182.google.com with SMTP id 00721157ae682-7e2fd65f968so54091377b3.3
        for <linux-unionfs@vger.kernel.org>; Tue, 23 Jun 2026 02:59:57 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1782208797; cv=none;
        d=google.com; s=arc-20240605;
        b=llxX6tEnMBlWACdUMeY9G1fjDuBLBrsBHUsfIlg+XMXeXtPEAQEaiagDdzwNtWNLSz
         F7sAkN2ZohIIOxtXWuZOP6StxF9KY8pValDP6UGZ0/pUpqbulafJv/f6mF6xw/zBIqvt
         YTyDLzlLOc0bGt/knodRSFZ6UskSuAies52Nztwj7BssYfRJ8vdtwhtPYoQ7oUPAHv4X
         1T1FknFWgitnL6J+qkiVUw9gAIJb+zohlVBU0xf+9vTYQW2AK7DNhy6hxiEmr4PfB7VG
         OhBFN5hleJoV7jyYcl1kcEj98X9GX/RJLhfbqOXjY28DEGeKtwyRgxRcWXaj1MtDtTd5
         GrFQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=mmXf8HVuYpDKq+qcKwNI47Acy6XixRYMjWA2gHcrCvI=;
        fh=YUf0hKbUG2PCHNYGWoTtDbFJzA2LZTzm2Vhn1FAiWAE=;
        b=Fw1XflBQVDPyu51f0mZ0ChDaTik7b3lXX0R67OQ2FS7QLe9m8S9Bn5dQIuV9jDB2io
         6THkTn8i7ebj3kcUEcg4lEoIb7LC9yJbOpG2QB+BzBV17KG9v49eTjCfpmn5E3K19vBD
         M0i8kXkQARIFqqnaBIRGDBSI913ZziUAk8gPLvPe/6ofTdzt+RLGEFTYyUtqqQ8T8mmW
         dIluNFZVxvI6VIozvsjJACWjSt+7QkJ/yab7LxH6s9wZT34BtyzXkBB7y/4NnrOUeQg5
         1HknABQOTx3O13rrrTFtSO7pPTOTvTND3BTxeEBQhD2J9frnJtJudLid9fNE7kDMFUfV
         9SYw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782208797; x=1782813597; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=mmXf8HVuYpDKq+qcKwNI47Acy6XixRYMjWA2gHcrCvI=;
        b=fSpeELSMOrokYSCn7NTlciDx5xOeWILr6MFK1RZJQK3hAJ2SRWS+lWJCTMX6WD7Aq/
         X0RW1syYR8IIelpHs9/oNHxVzpyWnLTxuitXmspsILWFPfLisNvJiALNcOf1P9sihFrP
         U//+v0gtD8nu+C9hBbjUZXD4AVTDldJVzLxicnC6wK8p9wbYLuJCk9m9P7+R+w0OjQMv
         acwiG2ztF5XXkbLtPvTcqEDQ5g7SabSo5AerzArjmDNu6QnSeM5uO9vEMtvGoTLJOjDS
         4RgGqIz+HFeHsHHOTKvJdfnGF3hwCOG0ZCvVAytFOKGircCZ1zwxxj4+Yz0yVPnXEQUq
         9u2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782208797; x=1782813597;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=mmXf8HVuYpDKq+qcKwNI47Acy6XixRYMjWA2gHcrCvI=;
        b=GSPiZixbT/L6FNxbV3o4MfqQpSa4U4qQVQ/xKBUD2uO6LX+aTitzu1XCLmhkcUhUsh
         QqPV+FhnYvtAXHp5QHQgQTtrozW/jCeUqMwECAtBsIQDqPcwsAkgsZGOjf+J6oQcBjaP
         Wz+B/QLGE/8QGfDopGULvOnc6OdAta/Xp47qYHNmsagPBrEfx908oasgalvFdsS2h7KL
         /HE7/d0/Xw8cJ6Of3uyKpvWZVbN7EXU0TvqoJtwtbNVVjwVrawRgKsJH3uo5tuwKJWZn
         F60fYJJuMlWJ4kGJ/4HRVm8J4srxaztR0H8FBgTZnU1TXBy4SZSC2Y2rk+EvgVsq+YnH
         v8Bg==
X-Forwarded-Encrypted: i=1; AHgh+RpW0u0x8Wzeza4EkGZ04hRpO+Tnr74hvptlRnpwIsrQWXEuB1L4GFMMPPv43An/ZH+LM9dRJVohpiPNfdh0@vger.kernel.org
X-Gm-Message-State: AOJu0Ywi2fbfFWLsVNHuNj/l6gWJ3SOJCV9Og6mnBkJPJK+W1i8SpDIi
	n2QzTc2S/A9Pc5VSD3k3xhxzG1uuS5zHSEhzclAbphbDmcFJerGEfiGDcKc57vi4XRDk5cM/u8t
	Iy4o6wIMEsUS4H2TB1VFYkTl7RkNmDoE=
X-Gm-Gg: AfdE7cn7oLFiuT8Ujl3xVTZGSRmm3C6PqRcmKNDbrP0qetatw4qrNSiATpdzSMNxGIl
	w4HuaxFzLjwWQ+Hok4D/6I7WPv8vG5/fatHs8xbflshA/I64kpBXd3gfsodYF0LsRfJn/VHP50r
	G7ZVaWEt5v0dv7H19KBebugOj/z7oA9lBMAXtEWLTVBdQyLXUXqZf3gbzoGWmEmor1am8dVbXep
	RqAHc2uaIrO9AZQajJbXSIt8eJQ6TLl4B8ujsb+IFa8mSM/KwYMg34UGpLamzJ246FSd1ypQj0K
	JjcQyzHZIR+5iYVvDtacQ9N5gJAZNg==
X-Received: by 2002:a05:690c:e3ec:b0:7fd:add6:f271 with SMTP id
 00721157ae682-8026722569fmr147798137b3.49.1782208796743; Tue, 23 Jun 2026
 02:59:56 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260623084337.54344-1-laoar.shao@gmail.com> <7c986c19-75d5-4092-a08a-4f865947e7ca@linux.alibaba.com>
 <CALOAHbCEgWi2MjFRO7o9mDtho5TnkLvruK8VgOE=zKdEB42AdA@mail.gmail.com>
 <80869b29-0791-4f63-8fa4-24bc039ce701@linux.alibaba.com> <CALOAHbAKVF7bLcT_RA8xP8djkSFBXfQiw8h=jCs_-jknnqHioQ@mail.gmail.com>
 <7f9e379c-186d-41de-926d-bfc020e6c87c@linux.alibaba.com>
In-Reply-To: <7f9e379c-186d-41de-926d-bfc020e6c87c@linux.alibaba.com>
From: Yafang Shao <laoar.shao@gmail.com>
Date: Tue, 23 Jun 2026 17:59:18 +0800
X-Gm-Features: AVVi8CePI3jQ0qk85nwkxdL8X1jiP21nj4_ut_yPb8tuc5godhqdgGWpgnDZCN0
Message-ID: <CALOAHbAY-3GAd=7DsA74W4ax7aPdXC7ecYt6b+tHoxFu754ZjA@mail.gmail.com>
Subject: Re: [PATCH] ovl: Allow changing default fsync_mode
To: Gao Xiang <hsiangkao@linux.alibaba.com>
Cc: miklos@szeredi.hu, amir73il@gmail.com, linux-unionfs@vger.kernel.org, 
	fuweid89@gmail.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Jun 23, 2026 at 5:49=E2=80=AFPM Gao Xiang <hsiangkao@linux.alibaba.=
com> wrote:
>
>
>
> On 2026/6/23 17:34, Yafang Shao wrote:
> > On Tue, Jun 23, 2026 at 5:25=E2=80=AFPM Gao Xiang <hsiangkao@linux.alib=
aba.com> wrote:
> >>
> >>
> >>
> >> On 2026/6/23 17:15, Yafang Shao wrote:
> >>> On Tue, Jun 23, 2026 at 5:00=E2=80=AFPM Gao Xiang <hsiangkao@linux.al=
ibaba.com> wrote:
> >>>>
> >>>>
> >>>>
> >>>> On 2026/6/23 16:43, Yafang Shao wrote:
> >>>>> We have enabled "volatile" fsync_mode on our Kubernetes production
> >>>>> environment to prevent container exit from being blocked when there
> >>>>> are many dirty pages to flush. This has worked well without introdu=
cing
> >>>>> any issues.
> >>>>>
> >>>>> However, on some of our production servers, upgrading the container
> >>>>> runtime to support the "volatile" mount option is not straightforwa=
rd [0].
> >>>>> To address this, we want to enable it by default within the kernel.
> >>>>
> >>>> Just a side note: "upgrade the container runtime is not
> >>>> straightforward", how? it seems that issue is already resolved and
> >>>> there is no more discussion.
> >>>
> >>> We still have many production servers running Docker, while the
> >>> "volatile" mount option is only supported by containerd. Upgrading
> >>> from Docker to containerd is a difficult process.
> >>
> >> But docker can be patched too: if upgrading the userspace is
> >> hard, why upgrading the linux kernel is easy?
> >
> > It is quite easy since the kernel can be livepatched without
> > rebooting. My employer is a heavy livepatch user. [1]
> >
> > [1]. https://lore.kernel.org/live-patching/
>
> It's just a generic opinion, in general, docker can be live
> upgraded without pausing the containers, and upgrading
> userspace is easier / safer than patching the kernel.

Are you sure? How would one change an already mounted overlayfs that
was not enabled with "volatile"?

>
> >
> >>
> >>>
> >>>>
> >>>> Not quite sure applying a default volatile policy is quite feasible,
> >>>> especially the issue documented in
> >>>> https://github.com/containerd/containerd/pull/10274/files#diff-92391=
61e2af83fd84df5792f9fe64701c517fe4598eae60d4d245d039955f46cR33
> >>>>
> >>>> then userspace cannot drop `volatile` option as a somewhat
> >>>> workaround now.
> >>>
> >>> OS vendors can still set "auto" as the default config, while customer=
s
> >>> can override it dynamically via sysfs. We have been running with
> >>> "volatile" on many production servers across different workloads for
> >>> over a year, and it has worked as expected without any issues.
> >>
> >> but sysfs setting still applies as system-wide, and there
> >> are some edge cases that we cannot apply volatile as
> >> default, that is my one concern.
> >
> > It is unclear whether there are mixed workloads on the same server
> > that require both "volatile" and "strict" modes, but we have not
> > encountered such use cases across our large fleet of servers.
>
> At least containerd needs to strip out `volatile` in some use cases,
> again see:
> https://github.com/containerd/containerd/pull/9555
> https://github.com/containerd/containerd/pull/10274/files#diff-9239161e2a=
f83fd84df5792f9fe64701c517fe4598eae60d4d245d039955f46cR33
>
> So set `volatile` as default will break userspace (containerd),
> and containerd needs to add another mount option to avoid the
> default `volatile` behavior, which is messy and makes the
> userspace more harder.

However, our userspace is easier with it ;)

>
> >
> >>
> >> The other concern is that since `volatile` omits fsync, so
> >> it's a posix violation (even that makes sense for container
> >> writable layers), not sure if we have to use it as the
> >> system-wide default configuration too.
> >
> > We have use cases for setting this as a system-wide configuration. It
> > is unclear whether others have similar needs.
>
> While I cannot speak out of overlayfs, but really it depends
> on if the use cases is generic.
>
> Usually filesystems need to obey posix semantics as much as
> possible, and using specific mount option to relax (violate)
> some restriction, but it shouldn't be a system-wide stuff
> since otherwise user applications cannot know if they really
> live in the posix world.

AFAICS, the Linux kernel does not strictly follow POSIX in a number of area=
s.

BTW,
1. The "volatile" is not the default option.
2. Even when the system-wide default is set to "volatile", users can
still change it per mount.

--=20
Regards
Yafang
