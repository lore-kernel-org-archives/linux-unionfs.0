Return-Path: <vgoyal@redhat.com>
From: Vivek Goyal <vgoyal@redhat.com>
Subject: [PATCH v2 0/4] ovl: Bunch of ovl_lookup() path fixes 
Date: Fri,  9 Mar 2018 15:44:40 -0500
Message-Id: <20180309204444.13237-1-vgoyal@redhat.com>
To: linux-unionfs@vger.kernel.org
Cc: miklos@szeredi.hu, amir73il@gmail.com, vgoyal@redhat.com
List-ID: <linux-unionfs@vger.kernel.org>

Hi,

Here are bunch of ovl_lookup() related fixes. These are cleanup also
and make some semantics more clear. Which should be useful when non-dir
dentries will have redirects. (metacopy patches).

Thanks
Vivek

Amir Goldstein (1):
  ovl: fix lookup with middle layer opaque dir and absolute path
    redirects

Vivek Goyal (3):
  ovl: Set d->last properly during lookup
  ovl: Do not check for redirect if this is last layer
  ovl: set d->is_dir and d->opaque for last path element

 fs/overlayfs/namei.c | 29 ++++++++++++++++++++++++-----
 1 file changed, 24 insertions(+), 5 deletions(-)

-- 
2.13.6
