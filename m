From: Al Viro <viro@ZenIV.linux.org.uk>
Subject: Re: overlayfs: allowing for changes to lowerdir
Date: Tue, 28 Feb 2017 19:44:57 +0000
Message-ID: <20170228194457.GU29622@ZenIV.linux.org.uk>
References: <CA+ZH+jFBAaRi6VPmf3PBdDZQQMOaT6WUByATqaw1QL5M9+-dxg@mail.gmail.com>
 <CAOQ4uxiBmFdcueorKV7zwPLCDq4DE+H8x=8H1f7+3v3zysW9qA@mail.gmail.com>
 <CA+ZH+jH9yoB5_wxyff088Fsm2-g5=oO1ECimHVo7u2SKVK4AAw@mail.gmail.com>
 <CAOQ4uxh5OVadTPLM-jw5J_6sRKBFv0WB_CTMdy68fe3dxtYsKA@mail.gmail.com>
 <CA+ZH+jE0k2hKoWTMZ2g-5vfU95OFxbW=WxGEC-umQM51vcC1gQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CA+ZH+jE0k2hKoWTMZ2g-5vfU95OFxbW=WxGEC-umQM51vcC1gQ@mail.gmail.com>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Josh England <jjengla@gmail.com>
Cc: Amir Goldstein <amir73il@gmail.com>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, linux-unionfs@vger.kernel.org, Miklos Szeredi <mszeredi@redhat.com>
List-Id: linux-unionfs@vger.kernel.org

On Tue, Feb 28, 2017 at 11:08:31AM -0800, Josh England wrote:

> The behavior I've noted so far from this patch seems to be very well
> defined and follows the rule of least surprise (at least for me).  I
> can change files/directories in the shared root and the changes are
> instantly visible to all clients.  If a file/directory has been copied
> up on the client that change takes precedence over changes in the
> lower.  Deletes work as expected.  I haven't found a downside yet.

Try to do something that invalidates a directory in underlying layer
with stuff in overlay on its subdirectories. 
