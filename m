Received: from mail-yw1-f172.google.com (mail-yw1-f172.google.com [209.85.128.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90D79215075
	for <linux-unionfs@vger.kernel.org>; Wed, 24 Jun 2026 03:41:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.128.172
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782272516; cv=pass; b=bm4deiDruW1uCEPJbfpge/WxXKwT3RuqkXzPzCZ3eT3bIiiDaYZ58ya7YxZLVBgyEt6mqcrvDq8AIKbA+bNfm8Aax4US3L3qKbSGeYpaDbQt41J6bEcH6WN5+kGHTDGoCKjqZnUw1lR6sLud9AkmK0ss/BKg3589fJLm2HBYuAY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782272516; c=relaxed/simple;
	bh=U2UuNuly4gL0+2XrDmm1FfmBDxpUxQXqduxxXaYs6N0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=lrZ7tZW2nkCrMJhC8o6hvqeb/HdJCHy52mxjzlFhiabMB1r2spETNrsZ3f+Sb8rJU70Wc5y/Sn2hCcKDJjy4kvJw/2t739XEBPSmHAPLONR6E44sRQO3Y9U9n6urCvOB2E4ftqYfF/Ba5o7tXkRcIdhUyhnQywxYKVGEZEG3dX8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=X4cqjH0U; arc=pass smtp.client-ip=209.85.128.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="X4cqjH0U"
Received: by mail-yw1-f172.google.com with SMTP id 00721157ae682-8000e21f014so8100787b3.2
        for <linux-unionfs@vger.kernel.org>; Tue, 23 Jun 2026 20:41:55 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1782272515; cv=none;
        d=google.com; s=arc-20240605;
        b=hfN3RKsuE4eFDGrH5kFZcYwaOg4YLg72FIXCfrPTOOqdF82qmzHoI2lScKkh8+Vxxm
         pSWPTSrU6dmIqhyNiwKAK3dHnFB33tmw4OWDPNYJKbfyXNhUuOt9cu5dXeYN+aGC069b
         VgpGwqchajtkqzVgWQ/3bd57JQ0gxlafhr2lVV5MBYiNr+5wyZO9a8rTq1z83KMst8PI
         Bb928xdfAfaarI5xot2xtEZD4yw2z/23MGFcFAhlMlQ8Nq/R4I5LxkM2/OSfaMGLUyrE
         jILsmcuLq34pDL3x1h7mheVdQ4b/+IB52qv/VNdY+1lbDDhjijp4cEMOsDuQo+gjdeUD
         5ItQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=P6Gk/nUwBGsoSlBgHUi/aDNnbDSHEio+4Fp7O2GUofM=;
        fh=G5qniHW7MJF0vGlw1W+/k5sVx443bptxbUFiGmufnJk=;
        b=FOzM3xpOdp8tMxoJ6BzqREYZCI4XrxTEZsE2xO6i0PvMvydsW7pTMYq4qnPuaZD5AT
         h6LZNik6VthWckCFMag2UtNWvEWqC9QB3fUCJC7bXpiAd1vNxoOLiJW114wFJHov3Lfm
         3+x8MJMf0BlPDgQQPCFksIhosztyC3KAd0iwaxtwivSCrxg88KQNzKyKDavroFh8BVn6
         DCnPA1s7KWDrEdUPYRVv3WLBp+zovRUrhSHN0BtlxYa0fAkT6Mo8zfba2YjA/Wgs5Iba
         ia5C/9tm+61jSWSxoN3aHfznSz71cZD11eXWwsX+elrcbyIiiNk+cZ3VwL1CawM1h76w
         LLmQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782272515; x=1782877315; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=P6Gk/nUwBGsoSlBgHUi/aDNnbDSHEio+4Fp7O2GUofM=;
        b=X4cqjH0Unohy2FbrpqCsgIIG24XxAGkUMF5Fs9QaM08+f44SOG+B5wd+/b3DbcmhdJ
         jhYIdj3u6I35IR7TbsXn0o/sz1y2sKnaNIPbCqnO1GaR6+Hzw4Q60h7IbrFU0cCic438
         85FbWYbDJDZgOZERZn6fThLqCodUjAk4S5Whe1fFHU4PXt9B9ssNfVzB0y4TmhpyJX9T
         tZW/+FxyOFivxmDX2tKTmzt6r/8aCneBAjrzYKrkMuiQGb0b5xuj4G1L/PVXcNl2K/Q4
         oJT+K9gMeU2opnmrtAT7ogIJ2aNVmvNENm9WJBaWhOzx7H2aceN6v2hjxRqAJV9kLUJR
         FvGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782272515; x=1782877315;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=P6Gk/nUwBGsoSlBgHUi/aDNnbDSHEio+4Fp7O2GUofM=;
        b=jNPxdVvLvp57+/Fh/vhgeTQ/ZXD5SUL/9j0p9kJxnLAD7zdCqumYbT/VGrHBdWbHhU
         /AT1f7INRwY5L/qLm/kQhZCzKaCxU9NJOmzf7J6PkK9F8z6AoumdroQ6hH/is0xRauKm
         60sy7ryWODJWfZi57sF+k7DmSxRI9p0YkkNxTMrpoEigCWz0tt+W/bCQVvBXBG9YTZaT
         ubmEVrWzzGyqjCPSR7uNk1DMEvNhHE8/XyhFvCCN7nBnnXyIQPejiVTotMrRmmYeagtK
         6LJXyCDuNI3GF00YtgRPUlAL6iW5v/t2c32TYIjYrdeYOUF+jvHFSa1UPajSQoYNh1zo
         UfBw==
X-Forwarded-Encrypted: i=1; AHgh+RqfqQTgsHXXon1GwaokdMppJFJA5oSaVyQ3WWEro+uIHIplmhrOROGx1Q097aArfMh380IonNHZgg7XoCpG@vger.kernel.org
X-Gm-Message-State: AOJu0YyMMxjztxiGXncCm+cZynlBthA2lwSYSYZQ8KYwXbM6HiJXQpgv
	HCyu0f1pDUVIo6XeMTF/sZo/oL49qlHVrC0rILZbq5as/P99mCMn3nWAmDavRcPFgYiYG/XoHfV
	SyHib4360FKvL2JLXcZTbHGHE02cRclI=
X-Gm-Gg: AfdE7cn5X8WCqmLy2XmGM0gZch1ds/gK4H1m9FOfu2wyGDxHac5Rqi442HjrU7oILbU
	cRSe2fK56AO9cvlaSxfXr2nrGIZS3Yo3KzcJpc04X1iSoMiN9oCR8tqbiDwc1QHaHcTlAzkHn7b
	FAkVbK0OcSXmpfVRymC9cMQyfIf1MGExb0SGHymJeF//Xs1MGxAysxjav7tO6s2XXkPycOhoYhW
	F/+WC9uAKtAvmH/hfdaXkcq11nu7V1c8MbF9P2hnjGR3cMjmzAgmRM2G15gF9eFGi8RUgQzTz9d
	inT+69UPsWASLjhF/X6e/HoR/fkN7k+8AHuscGh7
X-Received: by 2002:a05:690c:f0c:b0:7e9:9f7e:9f3 with SMTP id
 00721157ae682-807ef6322a8mr16184577b3.35.1782272514505; Tue, 23 Jun 2026
 20:41:54 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CALOAHbAY-3GAd=7DsA74W4ax7aPdXC7ecYt6b+tHoxFu754ZjA@mail.gmail.com>
 <ac56e537-d095-487b-8272-726d6739d0af@linux.alibaba.com> <CALOAHbCBo2eB0xVoSv8Vi+r3DwbwTticismFSL3EXyYuwFkEzA@mail.gmail.com>
 <13bb8cba-c82e-4a41-aff1-0a6418873bf1@linux.alibaba.com> <CALOAHbCkbSBVqUStUbWB=4vUUOEyB63yMsXvS_cZUZOwr-nmew@mail.gmail.com>
 <a5a1b56f-0b1a-473d-8fc9-8cbfba85813e@linux.alibaba.com> <CALOAHbCrvbvT04O3v+p-CmdqVN2BGJYKj6F7we70kPwbs-hmRw@mail.gmail.com>
 <b4d43064-7a7d-4d65-b65c-56e80d47ed17@linux.alibaba.com> <20260623134240.GA7980@lst.de>
 <1cc0931b-648e-4baf-9667-742175b3f9d0@linux.alibaba.com> <CAOQ4uxhURfuQWMd3y_W1iFebJms3aohn+koy5_sjxbcc4ZBQ-w@mail.gmail.com>
 <CALOAHbBjhqKZPqb9r8qoUoYfzpEe6wYU9By_cZtuGGmnoaAa5g@mail.gmail.com>
 <f650bed9-b049-4576-bbcf-6dd46028c5a4@linux.alibaba.com> <CALOAHbC=2AvZYWEUXR9bk2s=2jk_sVK6zimes1H-TK3iFnn_qQ@mail.gmail.com>
 <33912eb8-6b2c-40c2-b698-837e3f675d61@linux.alibaba.com> <CALOAHbDrWR0eRF9gST14Vm3xOimDZ=iLdn0zRFiF7OeBtqOD=A@mail.gmail.com>
 <56cdf083-99e9-4656-a353-f4d4670917b8@linux.alibaba.com>
In-Reply-To: <56cdf083-99e9-4656-a353-f4d4670917b8@linux.alibaba.com>
From: Yafang Shao <laoar.shao@gmail.com>
Date: Wed, 24 Jun 2026 11:41:18 +0800
X-Gm-Features: AVVi8CckYDPxpxM_bRXwTTUr5KwCRBp7mzrJEc2POq-lQJEUvksQEVYlqip4VFs
Message-ID: <CALOAHbDzuxZ1Nx+viPg33Fnb1aBLw_Sw4GFeM3ngshjGpVvdcA@mail.gmail.com>
Subject: Re: [PATCH] ovl: Allow changing default fsync_mode
To: Gao Xiang <hsiangkao@linux.alibaba.com>
Cc: conduct@kernel.org, Amir Goldstein <amir73il@gmail.com>, Christoph Hellwig <hch@lst.de>, 
	miklos@szeredi.hu, linux-unionfs@vger.kernel.org, fuweid89@gmail.com, 
	Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, 
	"linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, 
	derek@mcg.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Jun 24, 2026 at 11:36=E2=80=AFAM Gao Xiang <hsiangkao@linux.alibaba=
.com> wrote:
>
>
>
> On 2026/6/24 11:28, Yafang Shao wrote:
> > On Wed, Jun 24, 2026 at 11:17=E2=80=AFAM Gao Xiang <hsiangkao@linux.ali=
baba.com> wrote:
> >>
> >> Hi,
> >>
> >> On 2026/6/24 10:30, Yafang Shao wrote:
> >>> On Wed, Jun 24, 2026 at 10:28=E2=80=AFAM Gao Xiang <hsiangkao@linux.a=
libaba.com> wrote:
> >>>>
> >>>>
> >>>>
> >>>> On 2026/6/24 10:09, Yafang Shao wrote:
> >>>>> On Tue, Jun 23, 2026 at 10:52=E2=80=AFPM Amir Goldstein <amir73il@g=
mail.com> wrote:
> >>>>>>
> >>>>>> On Tue, Jun 23, 2026 at 3:47=E2=80=AFPM Gao Xiang <hsiangkao@linux=
.alibaba.com> wrote:
> >>>>
> >>>> ...
> >>>>
> >>>>>
> >>>>> Since the "volatile" option has been working fine for over a year
> >>>>> across our large fleet of Kubernetes production servers, I submitte=
d
> >>>>> this change to upstream. In Kubernetes environments, there is no us=
e
> >>>>> case for remounting the workdir to the same directory, so the volat=
ile
> >>>>> file won't cause any issues =E2=80=94 which is why the "volatile" s=
etting has
> >>>>> been working well there.
> >>>> That is not an excuse to introduce such new incompatible behavior
> >>>> to the linux upstream starting only for your customized fleet and
> >>>> bother every single opensource user/application to adapt this
> >>>> behavior which uses overlayfs now.
> >>>>
> >>>> If you insist to work on a breaking change, please gather
> >>>> userspace feedback boardly first.
> >>>>
> >>>> And here I just say you and your employer are lucky since I
> >>>> know it's also risky even on the generic kubernate perspective.
> >>>> Please just maintain your livepatch downstream, thanks.
> >>>>
> >>>> No need to reply, and I won't reply this either, it's just
> >>>> waste of my time to explain a basic upstream principle again
> >>>> and again.
> >>>
> >>> I'll just go ahead and redirect you to /dev/null ;)
> >>
> >> The whole thread is:
> >> https://lore.kernel.org/linux-unionfs/20260623084337.54344-1-laoar.sha=
o@gmail.com/T/#u
> >>
> >> Personally, I feel offensive due to Yafang's expression
> >> written above.  I keep maintain my replies in technical
> >> discussion, but the replies above already include the
> >> following words:
> >>
> >> "No wonder containerd is getting harder and harder to use ;)"
> >>
> >> "Please do your homework."
> >>
> >> "Again, pls do your homework."
> >>
> >> and the emotional texts `;)` make me feel uneasy over the
> >> time,
> >>
> >> especially the final words "I'll just go ahead and redirect
> >> you to /dev/null ;)"
> >>
> >> So I write an email as a public report to the CoC since I'm
> >> not sure how to proceed to comment the community patches
> >> because I could get offence as a result.
> >
> > I believe you could learn a thing or two from Amir about how to
> > comment on others' patches ;)
>
> ;) Please let me know why you commented:
>
> "No wonder containerd is getting harder and harder to use ;)"
>
> ;)

Because I find it harder to use than Docker ;)

--=20
Regards
Yafang
