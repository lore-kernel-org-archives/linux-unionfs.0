Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com [209.85.219.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47B6913AD29
	for <linux-unionfs@vger.kernel.org>; Fri, 29 Mar 2024 01:55:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711677314; cv=none; b=Fkp+HcByKc6D121iakM3WJOJYQlgG/yBJxW+yj48tEZqIs67KD38vHYKqHhJnhCkreNWA3Nqx5+CaS4Mhfsog2j3vDr8gon1isruXJZwTvG+5h1nwZkMbGQ2CtwWD2Ofrf9J9DZZK5d1ap07Kcg3+vov4t025yJjYep+2OgaTJo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711677314; c=relaxed/simple;
	bh=G/uTaIAkskzGcC6fM2pfc7BhIzgm1a5+YIJNknGkYno=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=rhz3czNf/MD39hNCb+bTpJPhjmbUpdAfIGQN6YKtBtYN5D/ykvJoEkwg6oeOoPaI7oX13k+FA0C0Re/taMJ7Bxy6IgAWeOUNAUMzOO1LD5qN5m+KjuG3GN3KoggqDxCAO+82gVEZNJGCrrFTdeldVVF9OkCbnzp2X18Pz6GFWtw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--drosen.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=q9s4HHGP; arc=none smtp.client-ip=209.85.219.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--drosen.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="q9s4HHGP"
Received: by mail-yb1-f201.google.com with SMTP id 3f1490d57ef6-dc743cc50a6so1959798276.2
        for <linux-unionfs@vger.kernel.org>; Thu, 28 Mar 2024 18:55:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1711677311; x=1712282111; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=7qesMvHPna2VGRQ3U+YOYTfZovmbGlRRDeWOIBEA3hQ=;
        b=q9s4HHGP1Y4POoajIPrDkRFEPdCRvS2tvrX+6OGtYUOgo4NIqyDXnOGi/KdTybGEet
         PQuVzJx312TkRUDLhPHbLLp2eesNLcj5SibFtAQpaPyFOMxS6FJa2ls9VhhB3WKCKdeE
         Wl2nvCV2mum0lFcjNmQ0oZ6ghC6BWszbC6BJCug9HPk62J7fLYPrd01vRMG9JuK1/Eyi
         eVt9xgde4BAUtQthbHOAF3WOTHlnmG2IbmAQJU8ev3xpRtu7S4IfkK6nDehk8TWKlbsc
         QPdg8fyRXRqCvJRUnrgNpMFM+q5eD5CCHdrP/nwMAOL+fdIgGKqYxkOFdrWs7B8j5QHK
         crRg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1711677311; x=1712282111;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=7qesMvHPna2VGRQ3U+YOYTfZovmbGlRRDeWOIBEA3hQ=;
        b=G6fJ7qinlyfVd1oVjSmeDxR6nboyRe3M23JLtlQL/hlIYr4alfDDXOh4Llr5OvianT
         cDO59VKS8vf7BWYxBqvCJxBTE44VxMzwNkDn0vf0G6eL2rZGvTOh45mxBi2ibPzhdfUK
         qg/BzATau6q6+zlq7o1MATwVPzsQQYnDtwY8oquLAjFmw2FbE2vE28BT5DIDzn1p3QdV
         6wR0TtS6O+JWVQqA7qJVsM7H/Mqw8FJC0KCWSy8W1vmvu+HQnfZZcz7Ci+w9QYuZTb39
         wB0vE7KzrxQXsXiY36c/XAAdX/i7m0Sp3p65zOxmLzT6y2eIloYnLhXt7UnFN1DdM76L
         CdPQ==
X-Forwarded-Encrypted: i=1; AJvYcCU12QkmP6wxhLlyNFuMih+nXxTMRC/IAzY93epUnJNkFgc0356SsN7p9w4pheEZEpcZFri7g7jmmjxw4oah3+0idcLx+BaXKHyCKQgpxg==
X-Gm-Message-State: AOJu0YwYJGzJhklmS8CmfWoPkrkTA35tfPPTqA4JxENb0uzuqAx/zui6
	E2/X+YIRdIP/7elozBSkdt4oL+k0NUYuGy7nOeiji8CH+nscxJRxAoB2IrJ7B+K9MT+xF1t9y7Q
	RSQ==
X-Google-Smtp-Source: AGHT+IGF9nW/lcLEYaeyMEZVwCHFKdI51EuE9NyugoSApHlrjqOTG5u7cGkQtddkr8oJLGW/eZgzFmc/WjM=
X-Received: from drosen.mtv.corp.google.com ([2620:15c:211:201:fcce:d6ab:804c:b94b])
 (user=drosen job=sendgmr) by 2002:a05:6902:2701:b0:dc2:5273:53f9 with SMTP id
 dz1-20020a056902270100b00dc2527353f9mr86822ybb.1.1711677311477; Thu, 28 Mar
 2024 18:55:11 -0700 (PDT)
Date: Thu, 28 Mar 2024 18:53:47 -0700
In-Reply-To: <20240329015351.624249-1-drosen@google.com>
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240329015351.624249-1-drosen@google.com>
X-Mailer: git-send-email 2.44.0.478.gd926399ef9-goog
Message-ID: <20240329015351.624249-33-drosen@google.com>
Subject: [RFC PATCH v4 32/36] WIP: fuse-bpf: add error_out
From: Daniel Rosenberg <drosen@google.com>
To: Miklos Szeredi <miklos@szeredi.hu>, bpf@vger.kernel.org, 
	Alexei Starovoitov <ast@kernel.org>
Cc: Amir Goldstein <amir73il@gmail.com>, linux-kernel@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, linux-unionfs@vger.kernel.org, 
	Daniel Borkmann <daniel@iogearbox.net>, John Fastabend <john.fastabend@gmail.com>, 
	Andrii Nakryiko <andrii@kernel.org>, Martin KaFai Lau <martin.lau@linux.dev>, Song Liu <song@kernel.org>, 
	Eduard Zingerman <eddyz87@gmail.com>, Yonghong Song <yonghong.song@linux.dev>, 
	KP Singh <kpsingh@kernel.org>, Stanislav Fomichev <sdf@google.com>, Hao Luo <haoluo@google.com>, 
	Jiri Olsa <jolsa@kernel.org>, Shuah Khan <shuah@kernel.org>, Jonathan Corbet <corbet@lwn.net>, 
	Joanne Koong <joannelkoong@gmail.com>, Mykola Lysenko <mykolal@fb.com>, 
	Christian Brauner <brauner@kernel.org>, kernel-team@android.com, 
	Daniel Rosenberg <drosen@google.com>
Content-Type: text/plain; charset="UTF-8"

error_out field will allow differentiating between altering error code
from bpf programs, and the bpf program returning an error. TODO

Signed-off-by: Daniel Rosenberg <drosen@google.com>
---
 include/linux/bpf_fuse.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/include/linux/bpf_fuse.h b/include/linux/bpf_fuse.h
index 159b850e1b46..15646ba59c41 100644
--- a/include/linux/bpf_fuse.h
+++ b/include/linux/bpf_fuse.h
@@ -57,6 +57,7 @@ struct bpf_fuse_meta_info {
 	uint64_t nodeid;
 	uint32_t opcode;
 	uint32_t error_in;
+	uint32_t error_out; // TODO: struct_op programs may set this to alter reported error code
 };
 
 struct bpf_fuse_args {
-- 
2.44.0.478.gd926399ef9-goog

