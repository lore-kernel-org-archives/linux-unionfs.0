Return-Path: <vgoyal@redhat.com>
From: Vivek Goyal <vgoyal@redhat.com>
Subject: [RFC PATCH 0/3] Misc ovl_lookup() related fixes
Date: Thu,  8 Mar 2018 17:18:01 -0500
Message-Id: <20180308221804.15708-1-vgoyal@redhat.com>
To: linux-unionfs@vger.kernel.org
Cc: miklos@szeredi.hu, amir73il@gmail.com, vgoyal@redhat.com
List-ID: <linux-unionfs@vger.kernel.org>

Hi Amir,

Here is another version of ovl_lookup() related fixes for the issues we
just talked.

I have tested first two patches and they don't seem to introduce
regressions. But third patch seemed to break tests/overlay/054. Not sure
yet why. Will look at it tomorrow.

This is still RFC and should fix d->last issue as well as issue of
setting d->is_dir and d->opaque for intermediate patch components.

What do you think?


Thanks
Vivek

Vivek Goyal (3):
  ovl: Set d->last properly during lookup
  ovl: Do not check for redirect if this is last layer
  ovl: set d->is_dir and d->opaque for last path element

 fs/overlayfs/namei.c | 27 ++++++++++++++++++---------
 1 file changed, 18 insertions(+), 9 deletions(-)

-- 
2.13.6
