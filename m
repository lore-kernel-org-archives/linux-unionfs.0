Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="M+WOgYjZ"
Received: from mail-qt1-x82a.google.com (mail-qt1-x82a.google.com [IPv6:2607:f8b0:4864:20::82a])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A3BF10D2
	for <linux-unionfs@vger.kernel.org>; Tue, 21 Nov 2023 02:31:55 -0800 (PST)
Received: by mail-qt1-x82a.google.com with SMTP id d75a77b69052e-42135f8e08fso33016741cf.1
        for <linux-unionfs@vger.kernel.org>; Tue, 21 Nov 2023 02:31:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1700562714; x=1701167514; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=uz2VtlxjMo+c0buPqQcgbnBSbefsRadbNLCrnLDR+oQ=;
        b=M+WOgYjZbZEPZZjc147Eo9794JhrNZX65sIqVw46UbTProYgL8vIb7xru9Jiu6Gjys
         ZVqMHyx7elL0FDzs8CBc9FBjT4r8qgZC0b+6lwYJ+vG9osk8mxj4Y23M4TOuVr72aryV
         dwAKiuSZNdGQ7J0I12PSfwCD9ySYeC1xcNUrDAvc2kFyzyHIK3WNfClzk2nbkcszU6T+
         +SaaqvkUYDdPpCoB9SpdAY+SA8LhigYn0svnrJKhTvpJGKizQwUHTcJpSKvoWc1NvrVT
         xi3JMGU5pw1d7wWvEmPf6g+7Y+oyl48lylPKsb4Z00Y02VMv4xZ/opqSsEvC/+QIpaws
         34RA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1700562714; x=1701167514;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=uz2VtlxjMo+c0buPqQcgbnBSbefsRadbNLCrnLDR+oQ=;
        b=oJ9gcjnIAEmzk+EgMYmTbqyelm85OyIQjHo29AO4oy1nW6/4KmB8hXKu5Qnt+UdbSb
         wX4vm9QdHn9a59bzaQmvQqgLkZ5edRbQgJ4CurT8bEf9Ey3egCMg+gcIsGcQec0Zs1Ho
         4jDhRbq8FAfycw9c4gLCzlho2id2BphCRBdrte9rF66kZiMQRkHJ7bd2K770aU7DGi3t
         WBmRGi6KUkw/S/f/OB2w8A7xSVFzWi8zxkxjxZxzKXJHhtt1/7LPn15xDSR3QtYHWJMO
         vK7AsD0l7DvFASoh2xEWULKUaN7x4+6fRSSkaOGAwycKjJ4PApK5YDkXwLqYhLJUt6aT
         tMxw==
X-Gm-Message-State: AOJu0Yxck0VFooS9PWD2kMWdEsQozw+oCCKj6HAPni5IXMQgp4C8K4lO
	O698/0xQ45whyC8/ikuhJIvtzFAwvC18AUO6DLk=
X-Google-Smtp-Source: AGHT+IEzfePZTS2E6Cwl8nz6X3t7dok10DkD7RXWHSms2bhf+mdVt7TFv0vRlDvrBE8i4PKyHVGr5rsXrgUgOwg5nPo=
X-Received: by 2002:a05:622a:4243:b0:423:756c:93f0 with SMTP id
 cq3-20020a05622a424300b00423756c93f0mr225841qtb.67.1700562714204; Tue, 21 Nov
 2023 02:31:54 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20231114072338.1669277-1-amir73il@gmail.com> <20231114072338.1669277-3-amir73il@gmail.com>
 <20231114105719.GB2325395@pevik> <20231121095946.GA88938@pevik>
In-Reply-To: <20231121095946.GA88938@pevik>
From: Amir Goldstein <amir73il@gmail.com>
Date: Tue, 21 Nov 2023 12:31:42 +0200
Message-ID: <CAOQ4uxi0=aAGeHpGFQxeGD=+mmEu7wRxxSVcrbQ2GEuKnHNCQw@mail.gmail.com>
Subject: Re: [LTP] [PATCH 2/2] fanotify13: Test watching overlayfs with FAN_REPORT_FID
To: Petr Vorel <pvorel@suse.cz>
Cc: ltp@lists.linux.it, Jan Kara <jack@suse.cz>, linux-unionfs@vger.kernel.org, 
	Miklos Szeredi <miklos@szeredi.hu>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Nov 21, 2023 at 11:59=E2=80=AFAM Petr Vorel <pvorel@suse.cz> wrote:
>
> Hi Amir,
>
> > Hi Amir,
>
> > Reviewed-by: Petr Vorel <pvorel@suse.cz>
> > Few notes below.
>
> > > Run test variants watching overlayfs (over all supported fs)
> > > and reporting events with fid.
>
> > > This requires overlayfs support for AT_HANDLE_FID (kernel 6.6) and
> > > even with AT_HANDLE_FID file handles, only inode marks are supported.
>
> > > Signed-off-by: Amir Goldstein <amir73il@gmail.com>
> > > ---
> > >  testcases/kernel/syscalls/fanotify/fanotify.h | 28 ++++++++++++-----
> > >  .../kernel/syscalls/fanotify/fanotify13.c     | 31 ++++++++++++++++-=
--
> > >  2 files changed, 47 insertions(+), 12 deletions(-)
>
> > > diff --git a/testcases/kernel/syscalls/fanotify/fanotify.h b/testcase=
s/kernel/syscalls/fanotify/fanotify.h
> > > index 78424a350..a8aec6597 100644
> > > --- a/testcases/kernel/syscalls/fanotify/fanotify.h
> > > +++ b/testcases/kernel/syscalls/fanotify/fanotify.h
> > > @@ -79,8 +79,11 @@ static inline int safe_fanotify_mark(const char *f=
ile, const int lineno,
> > >  /*
> > >   * Helper function used to obtain fsid and file_handle for a given p=
ath.
> > >   * Used by test files correlated to FAN_REPORT_FID functionality.
> > > + *
> > > + * Returns 0 if normal NFS file handles are supported.
> > > + * Returns AT_HANDLE_FID, of only non-decodeable file handles are su=
pported.
> > s/ of / if /
> > I can fix this before merge.
>
> I dared to fix this and s/AT_HADNLE_FID/AT_HANDLE_FID/ and merge.
>

That's great!

> > Also I noticed (not related to this change) that #define AT_HANDLE_FID =
0x200
> > added in dc7b1332ab into testcases/kernel/syscalls/fanotify/fanotify.h =
should
> > have been in include/lapi/fanotify.h (this file is for fallback definit=
ions).
> > Tiny detail, which should be fixed afterwards.
>
> I also merged a cleanup of the fallback definitions.
>
> Thanks for maintaining fanotify tests!
>

Thank you!
Amir.
