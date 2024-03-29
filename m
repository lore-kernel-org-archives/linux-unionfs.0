Received: from mail-yw1-f202.google.com (mail-yw1-f202.google.com [209.85.128.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5AA16A8A0
	for <linux-unionfs@vger.kernel.org>; Fri, 29 Mar 2024 01:54:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711677297; cv=none; b=sQygbv1QwM4WNwfgmZs9f7USYBopkHSQ8Da8NnAjN1lbJ+HNKkwJl2Yl9jRQYi2VSKb7ROaJx02PbAq1zf6CIZ5JPxT37BDkEfSM5tqsSeZg/VtzAmdRTDWwYlw2S/PrkTX9qcd20aZalGZD/qlmNNCM2v5o7vPF4FnlGIm/to4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711677297; c=relaxed/simple;
	bh=pk9Ej0arFqeZkCMlr0ALuLSLryIAG82IwMSP2yyNpaA=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Hn/1xDVtSNwY4ic1UdtdePqYFzqHbDT9F+KEfr+3QiPT7ejzb++r6pCDN0yAt5YlGvFIir1rj0MmXeMl5KjzFyU+SmY4MMeucXIwcsoHFxTVLQ4olmJRErbVmPmFHmYERc4GMqPZE2r6mcGQ9vvfQNmMd2rF7roIaL0Lig2L/Xc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--drosen.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=c0KGDrY2; arc=none smtp.client-ip=209.85.128.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--drosen.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="c0KGDrY2"
Received: by mail-yw1-f202.google.com with SMTP id 00721157ae682-60cc00203faso29576057b3.2
        for <linux-unionfs@vger.kernel.org>; Thu, 28 Mar 2024 18:54:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1711677295; x=1712282095; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=+fgPCyEdk35RPimkCV3pdmwq6y+0q0t2sbyu7i903QQ=;
        b=c0KGDrY2SPDw7zdMWf7UKCH98zvhJzG5zHgEHZyv7iZqIWji2kfPU5fOBB0d+q7/tC
         sbc7rMYqc6L8RFBccXpQcrptd2BE1gQratTe3haaO2f8/xKijqG9k2WRACjCsoLy8NHd
         jei0sJMtzUZEah1ZaIuKQrxYyYgdSyrwVDRCLfZ7tFj0fSD5utRFrdQMe37n18DjgUaM
         wLN4HU0S9IDoEAgpwkPoEByCwPsq+dkz2chMXrVLay6J01QpCsAsQJkVfaPK56J/Uqa+
         WgWA9kIDia9oaW3km2QfVIYRnSedBxB+pKe87ftQGxhMBcW+J2CPYt0m66ERPTH2QYMb
         kpTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1711677295; x=1712282095;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=+fgPCyEdk35RPimkCV3pdmwq6y+0q0t2sbyu7i903QQ=;
        b=Ce7E48uwo8i+6AzX7bUfRjARtVbCZ0BtjLRZoKH2yi3ikvIscgVvxN3DCOFXzUBIDX
         TZ3aqU5NdAizX21ycA3to7yyFwTIe64lWElcDn4lj3sZn/Cx4tWnKWHiZN9ctQwanjGq
         jFmvK5qm+OkBIcn9cysz72XKZGLSA/VUtfHzD2GfUCOiQ/TTDu1vCPtJHXhN9o7E8/V+
         odsnTtEAe7EO6+px+nx9ic4VnMV+p4aXEzpMWJyD7MjW1uHn3rj7qt0DpjRwzRwqz9c5
         JcgDIQJLy4PeJo2kVvd3YnML0N5Z/nV1Z1hhVAD7dv8++iasFNOLWp9NIy2aYtFmSIaX
         6xYQ==
X-Forwarded-Encrypted: i=1; AJvYcCVXokCGWas/0WaRy4xRfc5vvQC68YOjYDyehDm82ULh9dTc4nOQxejfy74nrI5wtR3UW0AnHuCAk1VOMV/LD74IPDzdOkivQ1lpdCFfTg==
X-Gm-Message-State: AOJu0YwjseycVk+WTp3RhwZpRsFWqpwu1sw7mxaVFHT4q0kMsz6Jva4d
	0ROFNULsQav04wb6B8dsraPj7VFIOqmKBXbBvYnY9wRw1XD2HBYC2gGEZpEQNpXJDi33elezdcm
	fIQ==
X-Google-Smtp-Source: AGHT+IHo+ItJCz1vEMlMJs25DEazsRdzqnfW39HVVXO67q+uyT3d5CUr2ZMLHU+KkcK6U1vReIfsPel7clY=
X-Received: from drosen.mtv.corp.google.com ([2620:15c:211:201:fcce:d6ab:804c:b94b])
 (user=drosen job=sendgmr) by 2002:a0d:d9c8:0:b0:613:eb1a:6407 with SMTP id
 b191-20020a0dd9c8000000b00613eb1a6407mr266377ywe.9.1711677294719; Thu, 28 Mar
 2024 18:54:54 -0700 (PDT)
Date: Thu, 28 Mar 2024 18:53:39 -0700
In-Reply-To: <20240329015351.624249-1-drosen@google.com>
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240329015351.624249-1-drosen@google.com>
X-Mailer: git-send-email 2.44.0.478.gd926399ef9-goog
Message-ID: <20240329015351.624249-25-drosen@google.com>
Subject: [RFC PATCH v4 24/36] fuse-bpf: Add fuse-bpf constants
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

This adds constants that fuse_op programs will rely on for communicating
what action fuse should take next.

Signed-off-by: Daniel Rosenberg <drosen@google.com>
---
 include/uapi/linux/bpf.h | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
index 85ec7fc799d7..46c1a3e3166d 100644
--- a/include/uapi/linux/bpf.h
+++ b/include/uapi/linux/bpf.h
@@ -7461,4 +7461,16 @@ struct bpf_iter_num {
 	__u64 __opaque[1];
 } __attribute__((aligned(8)));
 
+/* Return Codes for Fuse BPF struct_op programs */
+#define BPF_FUSE_CONTINUE		0
+#define BPF_FUSE_USER			1
+#define BPF_FUSE_USER_PREFILTER		2
+#define BPF_FUSE_POSTFILTER		3
+#define BPF_FUSE_USER_POSTFILTER	4
+
+/* Op Code Filter values for BPF Programs */
+#define FUSE_OPCODE_FILTER	0x0ffff
+#define FUSE_PREFILTER		0x10000
+#define FUSE_POSTFILTER		0x20000
+
 #endif /* _UAPI__LINUX_BPF_H__ */
-- 
2.44.0.478.gd926399ef9-goog

