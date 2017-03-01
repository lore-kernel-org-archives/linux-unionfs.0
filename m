From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: overlayfs: allowing for changes to lowerdir
Date: Wed, 1 Mar 2017 13:15:17 +0200
Message-ID: <CAOQ4uxgW1O6dyHtP40qZPWJg3e4DaOw+Ar0T5-7iGz3pao8ORQ@mail.gmail.com>
References: <CA+ZH+jFBAaRi6VPmf3PBdDZQQMOaT6WUByATqaw1QL5M9+-dxg@mail.gmail.com>
 <CAOQ4uxiBmFdcueorKV7zwPLCDq4DE+H8x=8H1f7+3v3zysW9qA@mail.gmail.com>
 <CA+ZH+jH9yoB5_wxyff088Fsm2-g5=oO1ECimHVo7u2SKVK4AAw@mail.gmail.com>
 <CAOQ4uxh5OVadTPLM-jw5J_6sRKBFv0WB_CTMdy68fe3dxtYsKA@mail.gmail.com>
 <CA+ZH+jE0k2hKoWTMZ2g-5vfU95OFxbW=WxGEC-umQM51vcC1gQ@mail.gmail.com> <20170228194457.GU29622@ZenIV.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <20170228194457.GU29622@ZenIV.linux.org.uk>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Al Viro <viro@zeniv.linux.org.uk>, Miklos Szeredi <mszeredi@redhat.com>
Cc: Josh England <jjengla@gmail.com>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, linux-unionfs@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org

On Tue, Feb 28, 2017 at 9:44 PM, Al Viro <viro@zeniv.linux.org.uk> wrote:
> On Tue, Feb 28, 2017 at 11:08:31AM -0800, Josh England wrote:
>
>> The behavior I've noted so far from this patch seems to be very well
>> defined and follows the rule of least surprise (at least for me).  I
>> can change files/directories in the shared root and the changes are
>> instantly visible to all clients.  If a file/directory has been copied
>> up on the client that change takes precedence over changes in the
>> lower.  Deletes work as expected.  I haven't found a downside yet.
>
> Try to do something that invalidates a directory in underlying layer
> with stuff in overlay on its subdirectories.

That's an interesting test to run, but why does ovl_dentry_revalidate()
need to return 1/-ESTALE instead of ret?
Why not propagate the return values 0 and -ECHILD from NFS?

After all, NFS lower directory inode can be invalidated after lookup
and then other overlayfs ops (e.g. readdir) could fail with -ESTALE
just the same as those ops would fail directly over NFS. No?

What am I missing?
