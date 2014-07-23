From: sfjro@users.sourceforge.net
Subject: Re: aufs as root vor openvz CT
Date: Wed, 23 Jul 2014 11:59:18 +0900
Message-ID: <9782.1406084358@jrobl>
References: <CAKG6wnaq1BwLgMNy27i8ggzt_qMnUb0KVNQg=Z85nz1LbXttUg@mail.gmail.com>
	<29716.1405886425@jrobl>
	<CAKG6wnYsDk8_JoG8QrHZ3ZtDicnwt__6AGTod-Ozqi5gjoZTdw@mail.gmail.com>
	<1728348.LhyPPIypjG@xrated>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <aufs-users-bounces@lists.sourceforge.net>
In-Reply-To: <1728348.LhyPPIypjG@xrated>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/aufs-users>,
	<mailto:aufs-users-request@lists.sourceforge.net?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=aufs-users>
List-Post: <mailto:aufs-users@lists.sourceforge.net>
List-Help: <mailto:aufs-users-request@lists.sourceforge.net?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/aufs-users>,
	<mailto:aufs-users-request@lists.sourceforge.net?subject=subscribe>
Errors-To: aufs-users-bounces@lists.sourceforge.net
To: Hans-Peter Jansen <hpj@urpla.net>
Cc: aufs-users@lists.sourceforge.net, linux-unionfs@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org


Hello Pete,
Thank you very much for your contribution.
I've repeatedly asked Sergey how to reproduce and the details, but got
no good answers. I hope your contribution will make the details clearer.


Hans-Peter Jansen:
> In order to perform a proper suspend/resume cycle, the CT has to arrange 
> everything to the state before the suspend. Therefore, they track the opened 
> files, and restore their state during resume. Layering FS (LFS) do cause 
> problems in this scenario, since files opened by them don't belong to any 
> application running in the container.

I'd ask generic questions (to anyone).
- Is such handling done in the container, or in the generic linux
  checkpoint/restart?
- If it is done in the generic feature, then is the linux
  checkpoint/restart feature specific to the containers?
- If not, we will be able to reproduce without any containers, no
  openvz, no old kernel.

As a first step, I need to know the detail steps to reproduce the
problem since I don't know much about suspend/resume.


> So, either define a special open flag for LFS internal fds, which, I guess, is 
> rather unpopular, or define a respective fcntl, that those LFS should 
> implement. Otherwise, every CT needs to detect the internal fds of every LFS 
> implementation heuristically, which is the worst solution, of course.

It depends upon how CT finds the opend files.
I have another idea.
- add a notifier-chain into the suspend feature (if there is not
  currently).
- any module who opens a file internaly regists itself to the
  notifier-chain.
- when the suspend event is notified via the notifier-chain, the module
  handle it.


J. R. Okajima

------------------------------------------------------------------------------
Want fast and easy access to all the code in your enterprise? Index and
search up to 200,000 lines of code with a free copy of Black Duck
Code Sight - the same software that powers the world's largest code
search on Ohloh, the Black Duck Open Hub! Try it now.
http://p.sf.net/sfu/bds
