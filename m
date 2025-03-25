Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 535B21C5D50
	for <linux-unionfs@vger.kernel.org>; Tue, 25 Mar 2025 10:46:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742899602; cv=none; b=QsHnpDSUkqxgtO1F4CNDfq+/mUS2TUnogoSOmtnE0voDuM80N61RnbzN7dqm0FQt0qI7vHvIk9uMzcEyqfeuG/lRLJr/YDXwIB9vGDbS04re4LxtET3xRDmZdanNE6DtBJnkpwrecvNy0/4BSVipJmajvNdeN019LrTYM5HRaDw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742899602; c=relaxed/simple;
	bh=zS3iedtb9CGE+6AikF6XtcfJb/KtdMt4kbhmDjh5djU=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=DERvDWbkteg8D5sUZeNgXDJUfsb7UKumUAB0EMMwkce59SGUMGbBV6g9kKCV/3a+xxVhuQP0UY6J+JNmq3+T9a76x4ryWxhv0OLyPOiSg3+pDATL37UMG26C1ZqyVQKqyMBC3vVt880K0ttMvkiJlD+vS+KKiMwm3HtCIeY8ook=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=BLpjPo8t; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="BLpjPo8t"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1742899599;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=llfCjfXs/RkEx1xDFKie+QOsYGNOm/qxwhosEg+VjwI=;
	b=BLpjPo8t8Zf9xelyAXKCOL7RJLptgmd+wxX4na3OTuHYx7e6a75T9GRg7vvE09iLa8jl9f
	RmuqF+PzrBNZCXbRcY/C6Xa/U/H9Qx9AVvXPiJwR0D/I1brd5Vjtlk45/afqynD+3Fx6pl
	msfGu6coWQHYBqoMzZ7Obf3Da2BeN6g=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-515-ysEKikZTMEuXI3n2MfIekQ-1; Tue, 25 Mar 2025 06:46:37 -0400
X-MC-Unique: ysEKikZTMEuXI3n2MfIekQ-1
X-Mimecast-MFC-AGG-ID: ysEKikZTMEuXI3n2MfIekQ_1742899596
Received: by mail-wr1-f70.google.com with SMTP id ffacd0b85a97d-3914bc0cc4aso2775408f8f.3
        for <linux-unionfs@vger.kernel.org>; Tue, 25 Mar 2025 03:46:37 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742899596; x=1743504396;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=llfCjfXs/RkEx1xDFKie+QOsYGNOm/qxwhosEg+VjwI=;
        b=w7iJ9BgAu0ARZy/xjxUlerwiWhdE2Ql5V2rzk9B6scfo+DjiHOmsDynABhYIYiYwzb
         7TXkoxDIM5eUNmlBXpI08WYzsPGMKZZmcRKx8rjM8tVYRSYntAPWVk0eP3gRfW92RASn
         Uo/aeRHj8RZcoaKGuxabSM6J7wK9nvjjdmjvF7CBoZ0qlb4TMhxX3wJc5YD6hvEdSQHE
         Q0tUBaoY6Ryg3CE7asGcu1XEBWnfOQRjlh4LIUdbljllIb8iUJ29GvK90hcAR3fNStDo
         rOQBxZP5VTN9tKxsa5NllFLf3A8VoTySQPudC4+nevOxn8nTecO3rYo6FJNbGJTzKc42
         +ADQ==
X-Gm-Message-State: AOJu0Yxe5M19v/inba3LqRMWEnaplIgByFdXnJuGdg7gRBxZT4H53KIC
	8VAPN8t8EAEW0ASkEWsGr0qiz6QR//2JkeGk2Z1uhhSmMASWX5sLWFYbw7+1lBXOjZbMOxNubH4
	C1Cl08EE4OfIihxw8Co99qae/f51RbJlV+77lCAY73e0W3SoJGyNqbSy1XbwSD17T6Rl6Uo70HI
	95I+Y2/1KfV9Qa1xj7J5z/LcvvydUa5vB5lfE9lkH4rfI/7oY=
X-Gm-Gg: ASbGnct21u3C7XCW23sZgdHLNQvesfFWb9N+x4ZMg8f3ApDv8tiqyp0x5qCJKO1UUuG
	sk5hevTV60Bpvyn5Vmar8ntK/qKAjN/Qh8Uyf3dyqPXo0WAuTSb88ISe/wMkpIWD81V07PfxkUu
	RfegocfF4TVfWKm5VaKyijOqk/d3lhTEjUla64J1t3Cs71wK0wTDO0TJK3dv0IhW0wknHD7QR0E
	IT7zMS3Mv+DUoXMJcJC8+cSQ3Fz7FftJdmp/nX77vdOgmIsZJxnxxA3831yE/yspMrcHI7WiklO
	9SFSnDqIdAhbdMIowqEZbhs5g6V/H6ynYbLGIuGsc7fGaOcevj3YpJ9ObguNp0U2Ebo=
X-Received: by 2002:a5d:47a5:0:b0:390:f699:8c27 with SMTP id ffacd0b85a97d-3997f902e3dmr14212184f8f.12.1742899596267;
        Tue, 25 Mar 2025 03:46:36 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGbPImIP/lo9XeKEIz0Dxt34DSlVTLHymW8RqoW4OZVQLvzK6BjYDTV2S9svurxcLkem4p2mQ==
X-Received: by 2002:a5d:47a5:0:b0:390:f699:8c27 with SMTP id ffacd0b85a97d-3997f902e3dmr14212151f8f.12.1742899595810;
        Tue, 25 Mar 2025 03:46:35 -0700 (PDT)
Received: from maszat.piliscsaba.szeredi.hu (87-97-53-119.pool.digikabel.hu. [87.97.53.119])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3997f9a50c1sm13572203f8f.38.2025.03.25.03.46.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Mar 2025 03:46:35 -0700 (PDT)
From: Miklos Szeredi <mszeredi@redhat.com>
To: linux-unionfs@vger.kernel.org
Cc: Amir Goldstein <amir73il@gmail.com>,
	linux-fsdevel@vger.kernel.org,
	Giuseppe Scrivano <gscrivan@redhat.com>,
	Alexander Larsson <alexl@redhat.com>
Subject: [PATCH v2 0/5] ovl: metacopy/verity fixes and improvements
Date: Tue, 25 Mar 2025 11:46:28 +0100
Message-ID: <20250325104634.162496-1-mszeredi@redhat.com>
X-Mailer: git-send-email 2.49.0
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The main purpose of this patchset is allowing metadata/data-only layers to
be usable in user namespaces (without super user privs).

v2:
	- drop broken hunk in param.c (Amir)
	- patch header improvements (Amir)

---
Giuseppe Scrivano (1):
  ovl: remove unused forward declaration

Miklos Szeredi (4):
  ovl: don't allow datadir only
  ovl: make redirect/metacopy rejection consistent
  ovl: relax redirect/metacopy requirements for lower -> data redirect
  ovl: don't require "metacopy=on" for "verity"

 Documentation/filesystems/overlayfs.rst |  7 +++
 fs/overlayfs/namei.c                    | 77 ++++++++++++++++---------
 fs/overlayfs/overlayfs.h                |  2 -
 fs/overlayfs/params.c                   | 16 +----
 fs/overlayfs/super.c                    |  5 ++
 5 files changed, 66 insertions(+), 41 deletions(-)

-- 
2.49.0

