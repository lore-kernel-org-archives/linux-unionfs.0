Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Gl9SLUiA"
Received: from mail-qv1-xf2b.google.com (mail-qv1-xf2b.google.com [IPv6:2607:f8b0:4864:20::f2b])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E24752703;
	Mon,  4 Dec 2023 06:32:06 -0800 (PST)
Received: by mail-qv1-xf2b.google.com with SMTP id 6a1803df08f44-67a89dc1ef1so26345196d6.3;
        Mon, 04 Dec 2023 06:32:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1701700326; x=1702305126; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=kg+PCClOnuXysJ/gmJjszHPrKZx+04K4rhWC7Ff0Pfw=;
        b=Gl9SLUiA4Oe5G6xoIyFKJTE0JHWuxzgA1lIKgXzqEibJov9DN8go0vYmO+GJNYlfU+
         FwjE61f9lY8QxnU4fSOZ9agPJzWK8+giQgD/wviUWUHZLKMdfR8/bX0zF8FhIJB/axxx
         QGSnB0eh2q57F+39kKSwW62l0x42qZVlD/cEUmb4oqVczlR6as3CBm+3M8IzgCXDbD/Y
         V0AvkYWLEh5HOq7lV3MfnhAa2obX5HWLcEGaVXbqlPQ/P+mPvElgoa4aXJ/mu3ukjP0X
         4FR/zxgFmKqiZv3AaMB/NBZdmz/hpOh/WhvX9Tr+/BK8g70rs/JE2V7o2nZHFEjWVbGC
         IgOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701700326; x=1702305126;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=kg+PCClOnuXysJ/gmJjszHPrKZx+04K4rhWC7Ff0Pfw=;
        b=iiWRxeRfrb2twq3VnjJ+9Diigw16BN/diIuVtjcpyy3EsI+t/5iGnBOd7aFzoh/jsW
         6oHIDYYp4KE0jHyjwxQyoDGeJXfE9Ukx9NdOEBWW0IKOnPhq8CcqJc18D5+Mz7pVSHNf
         GkuWTaNQJo9Om+i0zRQmdKRyY39ZEdcbbhp6Hlzb/YwVwwWDNfRIDy8Tb4ML6yjjfD4m
         zqFJyZuXi3wxS4IpSSF9avDc7X45pm1xyfSerXTQG9FFHGxlx/vBOqs8dAbPSjP9hNA7
         0H0jVini51a5QdAjzmneIAv05BxH2lhk8ywfxCoTWeAJLsH9nuAt6bcoh5guBXCPB85e
         3G4g==
X-Gm-Message-State: AOJu0YyB54oh5X7+lSAuBvRKFG/w0Q3tpCuStmuuF/D1rMc6fahupIAn
	d4/dTgA8bQntZSJVuO46SY58F773ry/w5z38fcI=
X-Google-Smtp-Source: AGHT+IFnKDTLrwAgjTxI3hKTcUXhCbLeMbyBGovz3lX72/7bL891I5Pz+M5eQ0BURGvcV07vge7E41smul9ZkAAZgK4=
X-Received: by 2002:a05:6214:4255:b0:67a:a721:cae8 with SMTP id
 ne21-20020a056214425500b0067aa721cae8mr5384535qvb.73.1701700326003; Mon, 04
 Dec 2023 06:32:06 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20231114064857.1666718-1-amir73il@gmail.com>
In-Reply-To: <20231114064857.1666718-1-amir73il@gmail.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Mon, 4 Dec 2023 16:31:55 +0200
Message-ID: <CAOQ4uxjT724ifjbv=EbtbwfDLpCAtYFZk1ian0_6BtkcSzb99w@mail.gmail.com>
Subject: Re: [PATCH 0/4] Overlayfs tests for 6.7-rc1
To: Zorro Lang <zlang@redhat.com>
Cc: Alexander Larsson <alexl@redhat.com>, Miklos Szeredi <miklos@szeredi.hu>, linux-unionfs@vger.kernel.org, 
	fstests@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Nov 14, 2023 at 8:49=E2=80=AFAM Amir Goldstein <amir73il@gmail.com>=
 wrote:
>
> Zorro,
>
> This update contains 3 new overlayfs tests for new features added
> in v6.7-rc1.
>
> overlay/084, written by Alexander, tests the new nested xattrs feature.
> overlay/{085,086} test the new lowerdir+,datadir+ mount options.
>
> overlay/086 was partly forked from overlay/083, but overlay/083 is not
> sensitive to libmount version, because the escaped commas test is not
> related to any specific mount option, so it wasn't copied over.
>
> All the new tests do not run on older kernels.
>

Ping.

> Thanks,
> Amir.
>
> Alexander Larsson (1):
>   overlay: Add tests of nesting
>
> Amir Goldstein (3):
>   overlay: prepare for new lowerdir+,datadir+ tests
>   overlay: test data-only lowerdirs with datadir+ mount option
>   overlay: test parsing of lowerdir+,datadir+ mount options
>
>  common/overlay        |  27 ++++
>  tests/overlay/079     |  36 +++--
>  tests/overlay/084     | 169 +++++++++++++++++++++
>  tests/overlay/084.out |  61 ++++++++
>  tests/overlay/085     | 332 ++++++++++++++++++++++++++++++++++++++++++
>  tests/overlay/085.out |  42 ++++++
>  tests/overlay/086     |  81 +++++++++++
>  tests/overlay/086.out |   2 +
>  8 files changed, 735 insertions(+), 15 deletions(-)
>  create mode 100755 tests/overlay/084
>  create mode 100644 tests/overlay/084.out
>  create mode 100755 tests/overlay/085
>  create mode 100644 tests/overlay/085.out
>  create mode 100755 tests/overlay/086
>  create mode 100644 tests/overlay/086.out
>
> --
> 2.34.1
>
