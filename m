Return-Path: <amir73il@gmail.com>
Return-Path: <amir73il@gmail.com>
From: Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH] docs: filesystems: overlayfs: Rename overlayfs.txt to .rst
Date: Mon, 25 Nov 2019 12:16:26 +0200
Message-Id: <20191125101626.32722-1-amir73il@gmail.com>
To: Jonathan Corbet <corbet@lwn.net>
Cc: Miklos Szeredi <miklos@szeredi.hu>, linux-doc@vger.kernel.org, linux-unionfs@vger.kernel.org
List-ID: <linux-unionfs@vger.kernel.org>

It is already formatted as RST.

Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---

Hi John,

Not sure if this doc is up to standards, but it is already displayed
fairly well on github as .rst.

If you want me to make more changes to bring it into compliance, before
the rename please let me know what needs to be done.
Is there a script to check doc compliance?

Otherwise, you can just take this rename patch and leave it to other
devlopers to clean it up.

Thanks,
Amir.

 Documentation/filesystems/{overlayfs.txt => overlayfs.rst} | 0
 1 file changed, 0 insertions(+), 0 deletions(-)
 rename Documentation/filesystems/{overlayfs.txt => overlayfs.rst} (100%)

diff --git a/Documentation/filesystems/overlayfs.txt b/Documentation/filesystems/overlayfs.rst
similarity index 100%
rename from Documentation/filesystems/overlayfs.txt
rename to Documentation/filesystems/overlayfs.rst
-- 
2.17.1
