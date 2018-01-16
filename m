From: Eryu Guan <eguan@redhat.com>
Subject: Re: [PATCH 7/7] overlay: test encode/decode of non-samefs overlay
 file handles
Date: Tue, 16 Jan 2018 15:42:28 +0800
Message-ID: <20180116074228.GI3102@eguan.usersys.redhat.com>
References: <1515348445-1403-1-git-send-email-amir73il@gmail.com>
 <1515348445-1403-8-git-send-email-amir73il@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1515348445-1403-8-git-send-email-amir73il@gmail.com>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Amir Goldstein <amir73il@gmail.com>
Cc: Jeff Layton <jlayton@poochiereds.net>, "J . Bruce Fields" <bfields@fieldses.org>, Miklos Szeredi <miklos@szeredi.hu>, fstests@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-unionfs@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org

On Sun, Jan 07, 2018 at 08:07:25PM +0200, Amir Goldstein wrote:
> This is a variant of overlay file handles test for an overlayfs that
> is composed of multiple lower layers not on the same underlying fs.
> 
> Signed-off-by: Amir Goldstein <amir73il@gmail.com>

This test follows the same pattern of overlay/050, I just noticed one
other issue. We don't have _overlay_check_dirs yet, so test failed
complaining (apart from the "+open_by_handle() returned 116 incorrectly
on a linked dir!" issue):

+./tests/overlay/051: line 126: _overlay_check_dirs: command not found

Thanks,
Eryu
